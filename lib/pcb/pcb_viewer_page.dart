// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'pcb_parser.dart';
// import 'pcb_painter.dart';
//
// class PcbViewerPage extends StatefulWidget {
//   final String filePath;
//
//   const PcbViewerPage({super.key, required this.filePath});
//
//   @override
//   State<PcbViewerPage> createState() => _PcbViewerPageState();
// }
//
// class _PcbViewerPageState extends State<PcbViewerPage> {
//   List<PcbComponent>? components;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPcb();
//   }
//
//   Future<void> _loadPcb() async {
//     final text = await rootBundle.loadString(widget.filePath);
//     final comps = parsePcb(text);
//
//     setState(() {
//       components = comps;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("PCB Viewer"),
//       ),
//       body: components == null
//           ? const Center(child: CircularProgressIndicator())
//           : InteractiveViewer(
//         minScale: 0.1,
//         maxScale: 10,
//         child: CustomPaint(
//           painter: PcbPainter(components!),
//           size: const Size(2000, 2000),
//         ),
//       ),
//     );
//   }
// }
