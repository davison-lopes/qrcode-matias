import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import '../model/qr.dart';
import '../repositorio/qr_repository.dart' as r;
import '../widgets/qrcode_list_item.dart';
import 'QRview.dart';
import 'pdf_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Qrcode> qrCodeResults = [];
  final r.QrRepository QrRepository = r.QrRepository();
  Qrcode? qrDelete;
  int? qrPosDelete;

  @override
  void initState() {
    super.initState();
    _loadQrCodes();
  }

  Future<void> _loadQrCodes() async {
    final loadedQrCodes = await QrRepository.getQr();
    setState(() {
      qrCodeResults = loadedQrCodes;
    });
  }

  Future<void> _saveQrCodes() async {
    await QrRepository.saveQrcodeList(qrCodeResults);
  }

  Future<void> _createPdf() async {
    final pdf = pw.Document();
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/qr_code_results${DateTime.now().minute}.pdf");

    const int itemsPerPage = 20;
    int currentPage = 0;

    for (int i = 0; i < qrCodeResults.length; i += itemsPerPage) {
      final pageContent = qrCodeResults.sublist(
        i,
        i + itemsPerPage > qrCodeResults.length ? qrCodeResults.length : i + itemsPerPage,
      );

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Header(level: 0, child: pw.Text('Alunos')),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Text('Nome', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Data e Hora', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    ...pageContent.map(
                          (qrcode) => pw.TableRow(
                        children: [
                          pw.Text(qrcode.title),
                          pw.Text(qrcode.dateTime.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      currentPage++;
    }

    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF saved at: ${file.path}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.list, color: Colors.white,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PdfListScreen()),
                );
              },
            ),
          ],
          backgroundColor: Colors.red,
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
          title: const Text("QR Code Scanner", style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final controller = MobileScannerController(torchEnabled: true);
                        final List<String>? results = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QRview(controller: controller)),
                        );
                        if (results != null) {
                          setState(() {
                            qrCodeResults.addAll(
                              results.map((result) => Qrcode(title: result, dateTime: DateTime.now())),
                            );
                            _saveQrCodes();  // Save QR codes after adding new ones
                          });
                        }
                        controller.dispose();
                      },
                      icon: const Icon(Icons.qr_code, size: 50, color: Colors.white,),
                      label: const Text("Ler QRCode", style: TextStyle(fontSize: 16, color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.black),
                        ),
                        elevation: 2,
                        shadowColor: Colors.redAccent,
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    child: VerticalDivider(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: ElevatedButton.icon(
                      onPressed: _createPdf,
                      icon: Icon(Icons.picture_as_pdf, size: 50, color: Colors.white),
                      label: Text("Gerar PDF", style: TextStyle(fontSize: 16, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.black),
                        ),
                        elevation: 2,
                        shadowColor: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),

            ),
            Container(
              child: Column(
                children: [

                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  SizedBox(height: 10,),
                  Text("Alunos", style: TextStyle(
                      color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,


                  ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: qrCodeResults.map((qrcode) => QrcodeListItem(
                          todo: qrcode,
                          onDelete: onDelete,
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.yellowAccent.withOpacity(0.4),
          child: Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Você possui ${qrCodeResults.length} alunos presentes',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black),
                  ),
                  backgroundColor: Colors.green,
                  disabledForegroundColor: Colors.green.withOpacity(0.38),
                  disabledBackgroundColor: Colors.green.withOpacity(0.12),
                  elevation: 20,
                  shadowColor: Colors.black12,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text('Limpar Tudo', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  _showClearConfirmationDialog();
                },
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }

  void onDelete(Qrcode qrcode) {
    qrDelete = qrcode;
    qrPosDelete = qrCodeResults.indexOf(qrcode);
    setState(() {
      qrCodeResults.remove(qrcode);
    });
    _saveQrCodes();  // Save QR codes after deleting one
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'O aluno ${qrcode.title} foi removido com sucesso',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xff00f0f0),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.red,
          onPressed: () {
            setState(() {
              qrCodeResults.insert(qrPosDelete!, qrDelete!);
            });
            _saveQrCodes();  // Save QR codes after undoing delete
          },
        ),
      ),
    );
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Tudo?'),
        content: const Text('Tem certeza que deseja prosseguir com esta ação?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearAllQrcodes();
            },
            child: const Text('Sim'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Não'),
          ),
        ],
      ),
    );
  }

  void _clearAllQrcodes() {
    setState(() {
      qrCodeResults.clear();
    });
    _saveQrCodes();  // Save QR codes after clearing all
  }
}
