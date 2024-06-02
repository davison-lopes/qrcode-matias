import 'package:flutter/material.dart';
import 'package:qrcode_matias/pages/home.dart';
import 'package:qrcode_matias/pages/initPage.dart';
import 'pages/QRview.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: initPage(),
    );
  }
}


