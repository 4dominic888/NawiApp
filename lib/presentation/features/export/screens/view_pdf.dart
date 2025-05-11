import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class ViewPdf extends StatelessWidget {

  final Uint8List pdfData;

  const ViewPdf({ super.key, required this.pdfData });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Visor de PDF")),
      body: PdfViewer.data(pdfData, sourceName: 'report_${DateTime.now().millisecondsSinceEpoch}.pdf',),
    );
  }
}