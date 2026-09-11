import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Gerbang pengiriman pesan WhatsApp melalui API Fonnte.
///
/// Token dan nomor pengembang dibaca dari file `.env` (lihat `.env.example`).
class LayananFonnte {
  static String get tokenFonnte => dotenv.env['FONNTE_TOKEN'] ?? '';
  static String get nomorWaPengembang => dotenv.env['WA_PENGEMBANG'] ?? '';
  static const String _url = 'https://api.fonnte.com/send';

  final http.Client _klien;

  LayananFonnte([http.Client? klien]) : _klien = klien ?? http.Client();

  Future<bool> kirim({
    required String target,
    required String pesan,
  }) async {
    try {
      final respons = await _klien
          .post(
            Uri.parse(_url),
            headers: {
              'Authorization': tokenFonnte,
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'target': target,
              'message': pesan,
              'typing': true,
              'delay': 3,
            }),
          )
          .timeout(const Duration(seconds: 15));
      return respons.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}