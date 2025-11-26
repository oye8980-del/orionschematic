// pcb2bmp_updated.dart
// Improved PCB .pcb (Protel/PADS) parser + Flutter viewer
// - Adds support for FPAD_* blocks, CP/CS parsing variants, @text markers
// - Normalizes very large coordinates (auto-shift) so board becomes visible
// - Auto-fit to max pixel dimensions by adjusting ctx.scale
// - Fixes toPxOffset coordinate -> pixel math
// - Keeps original simple primitives and drawing pipeline

import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';

// -------------------- Models --------------------

enum Layer {
  top, mid1, mid2, mid3, mid4, bottom, topOverlay, bottomOverlay,
  groundPlane, powerPlane, board, keepOut, multlayer
}

abstract class Primitive {
  Layer layer;
  Primitive(this.layer);
  void draw(Canvas c, Paint p, PCBContext ctx);
}

class Track extends Primitive {
  double x1, y1, x2, y2;
  double width;
  Track(Layer layer, this.x1, this.y1, this.x2, this.y2, this.width) : super(layer);
  @override
  void draw(Canvas c, Paint p, PCBContext ctx) {
    final paint = p..strokeWidth = ctx.scaleToPx(width);
    c.drawLine(ctx.toPxOffset(x1, y1), ctx.toPxOffset(x2, y2), paint);
  }
}

class Pad extends Primitive {
  double x, y, xdim, ydim;
  int shape; // 1 circle,2 square,4 rounded rect,3 octagon...
  Pad(Layer layer, this.x, this.y, this.xdim, this.ydim, this.shape) : super(layer);
  @override
  void draw(Canvas c, Paint p, PCBContext ctx) {
    final center = ctx.toPxOffset(x, y);
    final rx = ctx.scaleToPx(xdim / 2);
    final ry = ctx.scaleToPx(ydim / 2);
    if (shape == 1) {
      c.drawCircle(center, (rx + ry) / 2, p..style = PaintingStyle.fill);
    } else {
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
          Radius.circular(minDouble(rx, ry) * 0.2),
        ),
        p..style = PaintingStyle.fill,
      );
    }
  }
}

class Via extends Primitive {
  double x, y, size, holesize;
  Via(Layer layer, this.x, this.y, this.size, this.holesize) : super(layer);
  @override
  void draw(Canvas c, Paint p, PCBContext ctx) {
    final center = ctx.toPxOffset(x, y);
    final r = ctx.scaleToPx(size / 2);
    c.drawCircle(center, r, p..style = PaintingStyle.fill);
    final rr = ctx.scaleToPx(holesize / 2);
    // Erase hole by using clear blend mode if supported in context
    c.saveLayer(null, Paint());
    c.drawCircle(center, rr, p..blendMode = BlendMode.clear);
    c.restore();
  }
}

class FillRect extends Primitive {
  double x1, y1, x2, y2;
  FillRect(Layer layer, this.x1, this.y1, this.x2, this.y2) : super(layer);
  @override
  void draw(Canvas c, Paint p, PCBContext ctx) {
    final r = Rect.fromPoints(ctx.toPxOffset(x1, y1), ctx.toPxOffset(x2, y2));
    c.drawRect(r, p..style = PaintingStyle.fill);
  }
}

class ArcPrim extends Primitive {
  double cx, cy, radius;
  int quadrants;
  double width;
  ArcPrim(Layer layer, this.cx, this.cy, this.radius, this.quadrants, this.width) : super(layer);
  @override
  void draw(Canvas c, Paint p, PCBContext ctx) {
    final path = Path();
    if (quadrants == 15) {
      c.drawCircle(ctx.toPxOffset(cx, cy), ctx.scaleToPx(radius), p..style = PaintingStyle.stroke..strokeWidth = ctx.scaleToPx(width));
    } else {
      List<Map<String, double>> segs = [];
      if ((quadrants & 1) != 0) segs.add({'s': 0.0, 'e': 0.5 * pi});
      if ((quadrants & 2) != 0) segs.add({'s': 0.5 * pi, 'e': pi});
      if ((quadrants & 4) != 0) segs.add({'s': pi, 'e': 1.5 * pi});
      if ((quadrants & 8) != 0) segs.add({'s': 1.5 * pi, 'e': 2 * pi});
      final rect = Rect.fromCircle(center: ctx.toPxOffset(cx, cy), radius: ctx.scaleToPx(radius));
      for (final seg in segs) {
        path.addArc(rect, seg['s']!, seg['e']! - seg['s']!);
      }
      c.drawPath(path, p..style = PaintingStyle.stroke..strokeWidth = ctx.scaleToPx(width));
    }
  }
}

class TextPrim extends Primitive {
  double x, y, height;
  int orient;
  String text;
  TextPrim(Layer layer, this.x, this.y, this.height, this.orient, this.text) : super(layer);
  @override
  void draw(Canvas c, Paint p, PCBContext ctx) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: ctx.scaleToPx(height), color: p.color)),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    final pos = ctx.toPxOffset(x, y);
    Offset drawPos = pos;
    switch (orient & 3) {
      case 0:
        drawPos = pos - Offset(0, tp.height / 2);
        break;
      case 1:
        drawPos = pos - Offset(-tp.width / 2, tp.height / 2);
        break;
      case 2:
        drawPos = pos - Offset(tp.width / 2, tp.height);
        break;
      case 3:
        drawPos = pos - Offset(tp.width, tp.height / 2);
        break;
    }
    tp.paint(c, drawPos);
  }
}

// -------------------- PCB Context and Parser --------------------

class PCBContext {
  double hdpi = 96.0;
  double vdpi = 96.0;
  double scale = 1.0;
  double xmin = double.infinity, xmax = -double.infinity, ymin = double.infinity, ymax = -double.infinity;

  // Convert mils value (distance) to pixels
  double scaleToPx(double mils) {
    final inches = mils / 1000.0;
    return inches * hdpi * scale;
  }

  // Convert coordinates (mils) to canvas pixel offset
  Offset toPxOffset(double xMils, double yMils) {
    final pxPerMilX = hdpi * scale / 1000.0;
    final pxPerMilY = vdpi * scale / 1000.0;
    final x = (xMils - xmin) * pxPerMilX;
    // flip Y so that ymax maps to top = 0
    final y = (ymax - yMils) * pxPerMilY;
    return Offset(x, y);
  }
}

Layer parseLayer(int n) {
  switch (n) {
    case 1:
      return Layer.top;
    case 2:
      return Layer.mid1;
    case 3:
      return Layer.mid2;
    case 4:
      return Layer.mid3;
    case 5:
      return Layer.mid4;
    case 6:
      return Layer.bottom;
    case 7:
      return Layer.topOverlay;
    case 8:
      return Layer.bottomOverlay;
    case 9:
      return Layer.groundPlane;
    default:
      return Layer.board;
  }
}

class PCBDocument {
  final List<Primitive> primitives = [];
  final PCBContext ctx;

  PCBDocument(this.ctx);

  // Auto-fit maximum pixel width/height (adjust ctx.scale to fit)
  void fitToMaxPx(int maxPx) {
    final widthPx = ((ctx.xmax - ctx.xmin) / 1000.0 * ctx.hdpi * ctx.scale);
    final heightPx = ((ctx.ymax - ctx.ymin) / 1000.0 * ctx.vdpi * ctx.scale);
    final maxCurrent = max(widthPx, heightPx);
    if (maxCurrent <= maxPx) return;
    final factor = maxPx / maxCurrent;
    ctx.scale *= factor;
  }

  static PCBDocument fromPcbString(String pcbText, {double hdpi = 96.0, double vdpi = 96.0, double scale = 1.0, int fitMaxPx = 1200}) {
    final ctx = PCBContext()..hdpi = hdpi..vdpi = vdpi..scale = scale;
    final doc = PCBDocument(ctx);
    final lines = LineSplitter.split(pcbText).map((l) => l.trim()).toList();
    int i = 0;

    String peek() => i < lines.length ? lines[i] : '';
    String readLine() => i < lines.length ? lines[i++] : '';

    String pendingAtText = '';

    while (i < lines.length) {
      final l = readLine();
      if (l.isEmpty) continue;

      // capture lines that start with @ as text for the next CS block
      if (l.startsWith('@')) {
        pendingAtText = l.substring(1); // store without @
        continue;
      }

      // FPAD_x block (many pads use this tag in Protel 2.8)
      if (l.startsWith('FPAD')) {
        // next line contains numeric parameters like: 0 0 X Y rot shape ...
        final dataLine = peek();
        if (dataLine.isNotEmpty) {
          final tokens = dataLine.split(RegExp(r'\s+'));
          if (tokens.length >= 4) {
            // tokens[2], tokens[3] look like X Y in your samples
            try {
              final x = double.parse(tokens[2]);
              final y = double.parse(tokens[3]);
              // create a Pad placeholder small default size (will be overwritten by CP if present)
              doc._updateBounds(x, y);
              // sometimes shape not provided here, default to rectangle
              doc.primitives.add(Pad(Layer.top, x, y, 10000, 10000, 2));
            } catch (e) {
              // ignore parse errors
            }
          }
        }
        continue;
      }

      // CP line (component pad detailed) — when encountered, next numeric line provides dims
      if (l.startsWith('CP')) {
        final dataLine = peek();
        if (dataLine.isNotEmpty) {
          final tokens = dataLine.split(RegExp(r'\s+'));
          // attempt to find X,Y and pad sizes; Protel CP long format places X,Y at 2,3
          if (tokens.length >= 4) {
            try {
              final x = double.parse(tokens[2]);
              final y = double.parse(tokens[3]);
              // many CP lines include DimX DimY at 4,5 or immediately after; try best-effort
              double dx = 15000.0;
              double dy = 15000.0;
              int shape = 2;
              if (tokens.length >= 6) {
                dx = double.tryParse(tokens[4]) ?? dx;
                dy = double.tryParse(tokens[5]) ?? dy;
              }
              if (tokens.length >= 7) {
                shape = int.tryParse(tokens[6]) ?? shape;
              }
              doc._updateBounds(x - dx / 2, y - dy / 2);
              doc._updateBounds(x + dx / 2, y + dy / 2);
              doc.primitives.add(Pad(Layer.top, x, y, dx, dy, shape));
            } catch (e) {
              // ignore
            }
          }
        }
        continue;
      }

      // Track blocks (FT / CT) — your parser had this; keep it
      if (l.startsWith('FT') || l.startsWith('CT')) {
        final dataLine = readLine();
        final tokens = dataLine.split(RegExp(r'\s+'));
        if (tokens.length >= 7) {
          try {
            final x1 = double.parse(tokens[0]);
            final y1 = double.parse(tokens[1]);
            final x2 = double.parse(tokens[2]);
            final y2 = double.parse(tokens[3]);
            final width = double.parse(tokens[4]);
            final layer = parseLayer(int.parse(tokens[5]));
            doc._updateBounds(x1, y1);
            doc._updateBounds(x2, y2);
            doc.primitives.add(Track(layer, x1, y1, x2, y2, width));
          } catch (e) {}
        }
        continue;
      }

      // Pad legacy short form (FP / CP short) — try to support
      if (l.startsWith('FP') || l.startsWith('CP')) {
        final dataLine = readLine();
        final tokens = dataLine.split(RegExp(r'\s+'));
        if (tokens.length >= 7) {
          try {
            final x = double.parse(tokens[0]);
            final y = double.parse(tokens[1]);
            final xdim = double.parse(tokens[2]);
            final ydim = double.parse(tokens[3]);
            final shape = int.parse(tokens[4]);
            final layer = parseLayer(int.parse(tokens[6]));
            doc._updateBounds(x - xdim / 2, y - ydim / 2);
            doc._updateBounds(x + xdim / 2, y + ydim / 2);
            doc.primitives.add(Pad(layer, x, y, xdim, ydim, shape));
          } catch (e) {}
        }
        // optionally consume a following pin name line if present (non-capital start)
        final possiblePin = peek();
        if (possiblePin.isNotEmpty && !RegExp(r'^[A-Z]').hasMatch(possiblePin)) {
          readLine();
        }
        continue;
      }

      // Via FV/CV
      if (l.startsWith('FV') || l.startsWith('CV')) {
        final dataLine = readLine();
        final tokens = dataLine.split(RegExp(r'\s+'));
        if (tokens.length >= 4) {
          try {
            final x = double.parse(tokens[0]);
            final y = double.parse(tokens[1]);
            final size = double.parse(tokens[2]);
            final holesize = double.parse(tokens[3]);
            doc._updateBounds(x - size / 2, y - size / 2);
            doc._updateBounds(x + size / 2, y + size / 2);
            doc.primitives.add(Via(Layer.top, x, y, size, holesize));
          } catch (e) {}
        }
        continue;
      }

      // Fill rect FF/CF
      if (l.startsWith('FF') || l.startsWith('CF')) {
        final dataLine = readLine();
        final tokens = dataLine.split(RegExp(r'\s+'));
        if (tokens.length >= 5) {
          try {
            final x1 = double.parse(tokens[0]);
            final y1 = double.parse(tokens[1]);
            final x2 = double.parse(tokens[2]);
            final y2 = double.parse(tokens[3]);
            final layer = parseLayer(int.parse(tokens[4]));
            doc._updateBounds(x1, y1);
            doc._updateBounds(x2, y2);
            doc.primitives.add(FillRect(layer, x1, y1, x2, y2));
          } catch (e) {}
        }
        continue;
      }

      // Arc FA/CA
      if (l.startsWith('FA') || l.startsWith('CA')) {
        final dataLine = readLine();
        final tokens = dataLine.split(RegExp(r'\s+'));
        if (tokens.length >= 6) {
          try {
            final cx = double.parse(tokens[0]);
            final cy = double.parse(tokens[1]);
            final radius = double.parse(tokens[2]);
            final quad = int.parse(tokens[3]);
            final width = double.parse(tokens[4]);
            final layer = parseLayer(int.parse(tokens[5]));
            doc._updateBounds(cx - radius, cy - radius);
            doc._updateBounds(cx + radius, cy + radius);
            doc.primitives.add(ArcPrim(layer, cx, cy, radius, quad, width));
          } catch (e) {}
        }
        continue;
      }

      // Text FS/CS — support pending @text inserted before CS
      if (l.startsWith('FS') || l.startsWith('CS')) {
        final dataLine = readLine();
        final tokens = dataLine.split(RegExp(r'\s+'));
        if (tokens.length >= 5) {
          try {
            final x = double.parse(tokens[0]);
            final y = double.parse(tokens[1]);
            final height = double.parse(tokens[2]);
            final orient = int.parse(tokens[3]);
            final layer = parseLayer(int.parse(tokens[4]));
            // text content may follow in next line or be in pendingAtText
            String textLine = '';
            final next = peek();
            if (next.isNotEmpty && !RegExp(r'^[A-Z0-9_@]').hasMatch(next)) {
              textLine = readLine();
            } else if (pendingAtText.isNotEmpty) {
              textLine = pendingAtText;
            }
            pendingAtText = '';
            doc._updateBounds(x, y);
            doc.primitives.add(TextPrim(layer, x, y, height, orient, textLine));
          } catch (e) {}
        }
        continue;
      }

      // COMP block: skip until ENDCOMP (internal lines will be processed by above)
      if (l.startsWith('COMP')) {
        while (i < lines.length && !lines[i].startsWith('ENDCOMP')) {
          final inner = readLine();
          // inner lines may include FPAD_*, FP, CP, CS etc and will be handled by main loop
        }
        if (i < lines.length && lines[i].startsWith('ENDCOMP')) readLine();
        continue;
      }

      // fallback: ignore other header/metadata
    }

    // If bounds still infinite, set defaults to 0..1000
    if (ctx.xmin == double.infinity) {
      ctx.xmin = 0;
      ctx.xmax = 1000;
      ctx.ymin = 0;
      ctx.ymax = 1000;
    }

    // Normalize: shift coordinates so xmin/ymin -> 0
    doc.normalizeShiftToZero();

    // Auto-fit to maximum pixel size to keep widget reasonable
    doc.fitToMaxPx(fitMaxPx);

    return doc;
  }

  void _updateBounds(double x, double y) {
    if (x < ctx.xmin) ctx.xmin = x;
    if (x > ctx.xmax) ctx.xmax = x;
    if (y < ctx.ymin) ctx.ymin = y;
    if (y > ctx.ymax) ctx.ymax = y;
  }

  // Shift all primitives so that ctx.xmin/ctx.ymin become 0
  void normalizeShiftToZero() {
    final shiftX = ctx.xmin.isFinite ? ctx.xmin : 0.0;
    final shiftY = ctx.ymin.isFinite ? ctx.ymin : 0.0;
    if (shiftX == 0 && shiftY == 0) return;
    for (final p in primitives) {
      if (p is Track) {
        p.x1 -= shiftX; p.y1 -= shiftY; p.x2 -= shiftX; p.y2 -= shiftY;
      } else if (p is Pad) {
        p.x -= shiftX; p.y -= shiftY;
      } else if (p is Via) {
        p.x -= shiftX; p.y -= shiftY;
      } else if (p is FillRect) {
        p.x1 -= shiftX; p.y1 -= shiftY; p.x2 -= shiftX; p.y2 -= shiftY;
      } else if (p is ArcPrim) {
        p.cx -= shiftX; p.cy -= shiftY;
      } else if (p is TextPrim) {
        p.x -= shiftX; p.y -= shiftY;
      }
    }
    ctx.xmax -= shiftX; ctx.xmin = 0;
    ctx.ymax -= shiftY; ctx.ymin = 0;
  }

  Future<ui.Image> renderToImage({Color bg = Colors.white, double marginPx = 10.0}) async {
    final widthPx = ((ctx.xmax - ctx.xmin) / 1000.0 * ctx.hdpi * ctx.scale).ceil();
    final heightPx = ((ctx.ymax - ctx.ymin) / 1000.0 * ctx.vdpi * ctx.scale).ceil();
    final w = max(1, widthPx);
    final h = max(1, heightPx);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()));
    final paintBg = Paint()..color = bg;
    canvas.drawRect(Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()), paintBg);

    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (final prim in primitives) {
      if (prim is FillRect || prim is Pad || prim is Via) {
        prim.draw(canvas, fillPaint, ctx);
      } else {
        prim.draw(canvas, strokePaint, ctx);
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(w, h);
    return img;
  }

  Future<Uint8List> exportPngBytes({Color bg = Colors.white}) async {
    final img = await renderToImage(bg: bg);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

// -------------------- Flutter Widget to preview PCB --------------------

class PcbPainter extends StatefulWidget {
  final String pcbContent;
  final double hdpi;
  final double vdpi;
  final double scale;
  const PcbPainter({required this.pcbContent, this.hdpi = 96.0, this.vdpi = 96.0, this.scale = 1.0, super.key});
  @override
  _PcbPainterState createState() => _PcbPainterState();
}

class _PcbPainterState extends State<PcbPainter> {
  PCBDocument? doc;

  @override
  void initState() {
    super.initState();
    doc = PCBDocument.fromPcbString(widget.pcbContent, hdpi: widget.hdpi, vdpi: widget.vdpi, scale: widget.scale);
  }

  @override
  Widget build(BuildContext context) {
    if (doc == null) return const SizedBox(child: Text("empty doc"),);

    final width = ((doc!.ctx.xmax - doc!.ctx.xmin) / 1000.0 * doc!.ctx.hdpi * doc!.ctx.scale).clamp(1, 2000).toDouble();
    final height = ((doc!.ctx.ymax - doc!.ctx.ymin) / 1000.0 * doc!.ctx.vdpi * doc!.ctx.scale).clamp(1, 2000).toDouble();

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _PCBCanvasPainter(doc!),
      ),
    );
  }
}

class _PCBCanvasPainter extends CustomPainter {
  final PCBDocument doc;
  _PCBCanvasPainter(this.doc);
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, bg);

    final stroke = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fill = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    for (final p in doc.primitives) {
      if (p is FillRect || p is Pad || p is Via) {
        p.draw(canvas, fill, doc.ctx);
      } else {
        p.draw(canvas, stroke, doc.ctx);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------- Utilities --------------------

double minDouble(double a, double b) => a < b ? a : b;
