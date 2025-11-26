// import 'package:flutter/material.dart';
// import 'pcb_parser.dart';
//
// class PcbPainter extends CustomPainter {
//   final List<PcbComponent> components;
//
//   PcbPainter(this.components);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.greenAccent
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//
//     for (var comp in components) {
//       for (var block in comp.blocks) {
//         if (block.first.startsWith("FPAD_")) {
//           // Ambil data footprint utama
//           final parts = block[1].split(" ");
//           final x = int.parse(parts[2]) / 1000.0;
//           final y = int.parse(parts[3]) / 1000.0;
//
//           const padSize = 20.0;
//
//           canvas.drawRect(
//             Rect.fromCenter(center: Offset(x, y), width: padSize, height: padSize),
//             paint,
//           );
//         }
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
