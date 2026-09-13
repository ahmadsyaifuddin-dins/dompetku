import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Gerbang pengiriman pesan WhatsApp melalui API Fonnte.
///
/// Token dan nomor pengembang dibaca dari file `.env` (lihat `.env.example`).
/// Body dikirim sebagai form-urlencoded sesuai dokumentasi resmi Fonnte
/// (`target`, `message`, `typing`, `delay`). Di browser (web), request langsung
/// ke api.fonnte.com diblokir oleh CORS, sehingga diarahkan melalui proxy yang
/// menambahkan header CORS — diatur lewat `FONNTE_PROXY_URL`
/// (lihat `tool/worker_cors_proxy.js`).
class LayananFonnte {
  static String get tokenFonnte => dotenv.env['FONNTE_TOKEN'] ?? '';
  static String get nomorWaPengembang => dotenv.env['WA_PENGEMBANG'] ?? '';
  static const String _url = 'https://api.fonnte.com/send';

  /// URL efektif: di web, request dibungkus proxy CORS bila dikonfigurasi.
  /// Proxy menerima query `?<url-encoded>` (misal corsproxy.io atau worker).
  static String get _targetUrl {
    final proxy = dotenv.env['FONNTE_PROXY_URL']?.trim();
    if (!kIsWeb || proxy == null || proxy.isEmpty) return _url;
    final separator = proxy.endsWith('/') || proxy.endsWith('?') ? '' : '/';
    return '$proxy$separator${Uri.encodeComponent(_url)}';
  }

  final http.Client _klien;

  LayananFonnte([http.Client? klien]) : _klien = klien ?? http.Client();

  Future<HasilKirimFonnte> kirim({
    required String target,
    required String pesan,
  }) async {
    final token = tokenFonnte;
    if (token.isEmpty) {
      return const HasilKirimFonnte.gagal(
        'Token Fonnte belum diisi pada file .env.',
      );
    }

    try {
      final respons = await _klien
          .post(
            Uri.parse(_targetUrl),
            headers: {'Authorization': token},
            body: {
              'target': target,
              'message': pesan,
              'typing': 'true',
              'delay': '3',
            },
          )
          .timeout(const Duration(seconds: 15));
      return _bacaRespons(respons.statusCode, respons.body);
    } catch (_) {
      return const HasilKirimFonnte.gagal(
        'Kesalahan jaringan saat menghubungi Fonnte.',
      );
    }
  }

  HasilKirimFonnte _bacaRespons(int statusCode, String tubuh) {
    if (statusCode != 200) {
      return HasilKirimFonnte.gagal('Ditolak Fonnte (HTTP $statusCode).');
    }
    try {
      final data = jsonDecode(tubuh);
      if (data is Map) {
        final diterima = data['status'] ?? data['Status'];
        if (diterima == false) {
          final alasan = data['reason'] ?? data['detail'] ?? 'ditolak Fonnte';
          return HasilKirimFonnte.gagal('Fonnte: $alasan');
        }
      }
    } catch (_) {
      // Tubuh bukan JSON; HTTP 200 cukup sebagai tanda pesan diterima.
    }
    return const HasilKirimFonnte.berhasil();
  }
}

/// Hasil pengiriman pesan ke Fonnte.
class HasilKirimFonnte {
  final bool berhasil;
  final String? alasan;

  const HasilKirimFonnte.berhasil()
      : berhasil = true,
        alasan = null;

  const HasilKirimFonnte.gagal(this.alasan) : berhasil = false;
}