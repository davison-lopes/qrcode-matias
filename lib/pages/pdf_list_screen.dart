import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../PDF/PdfViewer.dart';

class PdfListScreen extends StatefulWidget {
  @override
  _PdfListScreenState createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  List<File> pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
  }

  Future<void> _loadPdfFiles() async {
    final directory = await getTemporaryDirectory();
    final files = directory
        .listSync()
        .where((file) => file.path.endsWith('.pdf'))
        .map((file) => File(file.path))
        .toList();
    setState(() {
      pdfFiles = files;
    });
  }

  void _openPdf(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewer(
          pdfName: file.path.split('/').last,
          path: file.path,
        ),
      ),
    );
  }

  void _deletePdf(File file) {
    file.deleteSync(); // Delete the file
    setState(() {
      pdfFiles.remove(file); // Remove the file from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PDFs Salvos',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadPdfFiles,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.red,
      ),
      body: pdfFiles.isEmpty
          ? const Center(
        child: Text('Nenhum PDF encontrado.'),
      )
          : ListView.builder(
        itemCount: pdfFiles.length,
        itemBuilder: (context, index) {
          final file = pdfFiles[index];
          return ListTile(
            title: Text(file.path.split('/').last),
            onTap: () => _openPdf(file), // Open the PDF viewer on tap
            onLongPress: () =>
                _deletePdf(file), // Delete the PDF on long press
          );
        },
      ),
    );
  }
}
