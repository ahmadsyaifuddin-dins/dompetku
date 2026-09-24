import 'dart:convert';

import 'package:dompetku/core/services/layanan_fonnte.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  setUpAll(() {
    dotenv.loadFromString(
      envString: 'FONNTE_TOKEN=token_uji\nWA_PENGEMBANG=628123456789',
    );
  });

  group('LayananFonnte.kirim', () {
    test('mengirim multipart/form-data lengkap dengan Authorization', () async {
      late http.Request tangkapan;
      final mock = MockClient((permintaan) async {
        tangkapan = permintaan;
        return http.Response(jsonEncode({'status': true}), 200,
            headers: {'content-type': 'application/json'});
      });
      final layanan = LayananFonnte(mock);

      final hasil = await layanan.kirim(
        target: '6285849910396',
        pesan: 'halo',
      );

      expect(hasil.berhasil, isTrue);
      expect(hasil.alasan, isNull);
      expect(tangkapan.headers['Authorization'], 'token_uji');
      expect(
        tangkapan.headers['Content-Type'],
        contains('multipart/form-data'),
      );
      expect(tangkapan.body, contains('name="target"'));
      expect(tangkapan.body, contains('6285849910396'));
      expect(tangkapan.body, contains('name="message"'));
      expect(tangkapan.body, contains('halo'));
      expect(tangkapan.body, contains('name="typing"'));
      expect(tangkapan.body, contains('true'));
    });

    test('gagal saat Fonnte menolak token', () async {
      final mock = MockClient(
        (_) async => http.Response(
          jsonEncode({'Status': false, 'reason': 'token invalid'}),
          200,
        ),
      );

      final hasil = await LayananFonnte(mock).kirim(
        target: '628123456789',
        pesan: 'hai',
      );

      expect(hasil.berhasil, isFalse);
      expect(hasil.alasan, contains('token invalid'));
    });

    test('gagal saat HTTP bukan 200', () async {
      final mock = MockClient((_) async => http.Response('{}', 401));

      final hasil = await LayananFonnte(mock).kirim(
        target: '628123456789',
        pesan: 'hai',
      );

      expect(hasil.berhasil, isFalse);
      expect(hasil.alasan, contains('401'));
    });

    test('testing body yang bukan JSON dianggap berhasil bila HTTP 200',
        () async {
      final mock = MockClient((_) async => http.Response('ok', 200));

      final hasil = await LayananFonnte(mock).kirim(
        target: '628123456789',
        pesan: 'hai',
      );

      expect(hasil.berhasil, isTrue);
    });
  });
}