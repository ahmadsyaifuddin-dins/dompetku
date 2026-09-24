import 'dart:io';

import 'package:dompetku/core/services/layanan_fonnte.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const aktif = bool.fromEnvironment('KIRIM_FONNTE_LIVE');
  if (!aktif) return;

  test(
    'kirim pesan tes ke nomor pengembang lewat API Fonnte',
    () async {
      // Inisialisasi dotenv dulu, lalu muat .env langsung dari cakram
      // (test berjalan di akar proyek).
      dotenv.loadFromString(envString: 'INIT=1');
      for (final baris in File('.env').readAsLinesSync()) {
        final bersih = baris.trim();
        if (bersih.isEmpty || bersih.startsWith('#')) continue;
        final pisah = bersih.indexOf('=');
        if (pisah <= 0) continue;
        dotenv.env[bersih.substring(0, pisah).trim()] =
            bersih.substring(pisah + 1).trim();
      }
      expect(
        LayananFonnte.tokenFonnte,
        isNotEmpty,
        reason: 'FONNTE_TOKEN harus ada di .env',
      );

      final kiriman = LayananFonnte();
      final hasil = await kiriman.kirim(
        target: LayananFonnte.nomorWaPengembang,
        pesan: '🚀 Tes koneksi DompetKu: jalur notifikasi WhatsApp berhasil.',
      );

      // ignore: avoid_print
      print(
        'hasil kirim => berhasil=${hasil.berhasil} '
        'alasan=${hasil.alasan}',
      );
      expect(hasil.berhasil, isTrue, reason: hasil.alasan);
    },
    timeout: const Timeout(Duration(seconds: 45)),
  );
}