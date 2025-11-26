// import 'package:flutter/material.dart';
// import 'package:orionschematic/pcb2bmp.dart';
// import 'package:flutter/services.dart' show rootBundle;
//
//
// Future<String> readAssetFile() async {
//   return await rootBundle.loadString('assets/G532F.pcb');
// }
//
// class PcbPage extends StatefulWidget {
//   const PcbPage({super.key});
//
//   @override
//   State<PcbPage> createState() => _PcbPageState();
// }
//
// class _PcbPageState extends State<PcbPage> {
//   String pcbContent = "";
//
//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }
//
//   void loadData() async {
//     final data = await readAssetFile();
//
//     setState(() {
//       pcbContent = data;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return pcbContent.isEmpty
//         ? const Center(child: CircularProgressIndicator())
//         : PcbPainter(pcbContent: pcbContent);
//   }
// }