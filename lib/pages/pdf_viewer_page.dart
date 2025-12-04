import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatelessWidget {
  final String pdfPath; // contoh: assets/schematic/a12.pdf

  const PDFViewerPage({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schematic Viewer")),
      body: SfPdfViewer.asset(pdfPath),
    );
  }
}
