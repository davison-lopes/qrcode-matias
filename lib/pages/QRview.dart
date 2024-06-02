import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_matias/widgets/scanner_error_widget.dart';

class QRview extends StatefulWidget {
  final MobileScannerController controller;

  const QRview({Key? key, required this.controller}) : super(key: key);

  @override
  _QRviewState createState() => _QRviewState();
}

class _QRviewState extends State<QRview> {
  late final List<String> qrCodeResults;

  @override
  void initState() {
    super.initState();
    qrCodeResults = [];
    _startCapture();
  }

  void _startCapture() {
    widget.controller.start();
    widget.controller.barcodes.listen((barcodeCapture) {
      final barcodes = barcodeCapture.barcodes;
      for (var barcode in barcodes) {
        if (barcode.rawValue != null && !qrCodeResults.contains(barcode.rawValue!)) {
          setState(() {
            qrCodeResults.add(barcode.rawValue!);
          });
          _showQRResultDialog(barcode.rawValue!);
        }
      }
    });
  }


  void _showQRResultDialog(String result) {
    showDialog(
      context: context,
      barrierDismissible: true,  // Allow dismiss when tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop(qrCodeResults);
            return true;
          },
          child: AlertDialog(
            title: Text('QR Code Result'),
            content: Text(result),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(qrCodeResults);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: widget.controller,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            fit: BoxFit.contain,
          ),
          Align(
            alignment: Alignment.center,
            child: CustomPaint(
              painter: GuidePainter(),
              child: const SizedBox(
                width: 250,
                height: 250,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    onPressed: () => widget.controller.toggleTorch(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () => Navigator.pop(context, qrCodeResults),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.switch_camera, color: Colors.white),
                    onPressed: () => widget.controller.switchCamera(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.white),
                    onPressed: () async {
                      // Implement logic to select image from gallery
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
