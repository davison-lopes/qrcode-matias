import 'package:shared_preferences/shared_preferences.dart';
import '../model/qr.dart';
import 'dart:convert';

class QrRepository {
  static const String qrCodeKey = 'qrcode_list';

  Future<List<Qrcode>> getQr() async {
    final prefs = await SharedPreferences.getInstance();
    final String? qrCodeString = prefs.getString(qrCodeKey);
    if (qrCodeString != null) {
      final List<dynamic> decodedList = jsonDecode(qrCodeString);
      return decodedList.map((json) => Qrcode.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveQrcodeList(List<Qrcode> qrCodes) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(qrCodes.map((qr) => qr.toJson()).toList());
    await prefs.setString(qrCodeKey, encodedList);
  }
}
