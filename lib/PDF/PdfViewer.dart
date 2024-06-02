import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:universal_html/html.dart' as html;

class PdfViewer extends StatefulWidget {
  const PdfViewer({
    required this.pdfName,
    required this.path,
    super.key,
  });

  final String pdfName;
  final String path;

  @override
  PdfViewerState createState() => PdfViewerState();
}

class PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 1,
        title: Text(
          widget.pdfName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.white, letterSpacing: 2, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_sharp),
            onPressed: _downloadPdf,
          ),
        ],
      ),
      body: PDFView(
        filePath: widget.path,
      ),
    );
  }

  void _downloadPdf() {
    if (!kIsWeb) {
      try {
        Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async {
            final file = File(widget.path);
            return file.readAsBytes();
          },
        );
      } catch (e) {
        log(e.toString());
      }
    } else {
      _downloadPdfWeb(widget.path);
    }
  }

  void _downloadPdfWeb(String url) {
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', widget.pdfName)
      ..click();
    html.document.body!.children.remove(anchor);
  }
}
