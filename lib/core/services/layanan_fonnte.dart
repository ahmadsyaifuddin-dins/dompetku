import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Gerbang pengiriman pesan WhatsApp melalui API Fonnte.
///
/// Token dan nomor pengembang dibaca dari file `.env`.
/// Request dikirim menggunakan multipart/form-data sesuai pola
/// request yang digunakan pada dokumentasi API Fonnte.
///
/// Pada Web, request diarahkan melalui proxy CORS bila
/// `FONNTE_PROXY_URL` dikonfigurasi.
/// Pada Android/iOS/Desktop, request langsung ke API Fonnte.
class LayananFonnte {
  static String get tokenFonnte =>
      dotenv.env['FONNTE_TOKEN']?.trim() ?? '';

  static String get nomorWaPengembang =>
      dotenv.env['WA_PENGEMBANG']?.trim() ?? '';

  static const String _url = 'https://api.fonnte.com/send';

  /// URL efektif:
  /// - Web + proxy terisi → menggunakan proxy.
  /// - Selain itu → langsung ke Fonnte.
  ///
  /// Format proxy mengikuti konfigurasi project:
  /// proxy + URL Fonnte yang sudah di-encode.
  static String get _targetUrl {
    final proxy = dotenv.env['FONNTE_PROXY_URL']?.trim();

    if (!kIsWeb || proxy == null || proxy.isEmpty) {
      return _url;
    }

    final separator =
        proxy.endsWith('/') || proxy.endsWith('?') ? '' : '/';

    return '$proxy$separator${Uri.encodeComponent(_url)}';
  }

  final http.Client _klien;

  LayananFonnte([http.Client? klien])
      : _klien = klien ?? http.Client();

  /// Mengirim pesan WhatsApp melalui API Fonnte.
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

    final targetBersih = target.trim();

    if (targetBersih.isEmpty) {
      return const HasilKirimFonnte.gagal(
        'Nomor tujuan WhatsApp kosong.',
      );
    }

    if (pesan.trim().isEmpty) {
      return const HasilKirimFonnte.gagal(
        'Pesan WhatsApp kosong.',
      );
    }

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_targetUrl),
      );

      request.headers['Authorization'] = token;

      request.fields['target'] = targetBersih;
      request.fields['message'] = pesan;
      request.fields['typing'] = 'true';
      request.fields['delay'] = '3';

      final streamedResponse = await _klien
          .send(request)
          .timeout(const Duration(seconds: 15));

      final tubuh =
          await streamedResponse.stream.bytesToString();

      return _bacaRespons(
        streamedResponse.statusCode,
        tubuh,
      );
    } catch (galat) {
      return HasilKirimFonnte.gagal(
        'Kesalahan saat menghubungi Fonnte: '
        '${galat.runtimeType}: $galat',
        detail: _targetUrl,
      );
    }
  }

  HasilKirimFonnte _bacaRespons(
    int statusCode,
    String tubuh,
  ) {
    final ringkas = tubuh.length <= 1000
        ? tubuh
        : '${tubuh.substring(0, 1000)}…';

    if (statusCode < 200 || statusCode >= 300) {
      return HasilKirimFonnte.gagal(
        'Ditolak Fonnte (HTTP $statusCode).',
        detail: 'status=$statusCode tubuh=$ringkas',
      );
    }

    try {
      final data = jsonDecode(tubuh);

      if (data is Map) {
        final status = data['status'] ?? data['Status'];

        if (status == false ||
            status == 'false' ||
            status == 0) {
          final alasan =
              data['reason'] ??
              data['detail'] ??
              'Ditolak Fonnte';

          return HasilKirimFonnte.gagal(
            'Fonnte: $alasan',
            detail: ringkas,
          );
        }

        return HasilKirimFonnte.berhasil(
          detail: ringkas,
        );
      }
    } catch (_) {
      // Jika response bukan JSON, tetap dianggap diterima
      // selama HTTP berada pada rentang 2xx.
    }

    return HasilKirimFonnte.berhasil(
      detail: ringkas,
    );
  }
}

/// Hasil pengiriman pesan ke Fonnte.
class HasilKirimFonnte {
  final bool berhasil;
  final String? alasan;
  final String? detail;

  const HasilKirimFonnte.berhasil({
    this.detail,
  })  : berhasil = true,
        alasan = null;

  const HasilKirimFonnte.gagal(
    this.alasan, {
    this.detail,
  }) : berhasil = false;
}