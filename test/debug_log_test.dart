import 'package:dompetku/core/services/layanan_fonnte.dart';
import 'package:dompetku/core/services/layanan_preferensi.dart';
import 'package:dompetku/fitur/onboarding/onboarding_controller.dart';
import 'package:dompetku/komponen/debug/log_debug.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    DebugLog.saya.bersihkan();
    dotenv.loadFromString(
      envString: 'FONNTE_TOKEN=token_uji\nWA_PENGEMBANG=62881025649838',
    );
  });

  group('LogDebug', () {
    test('menyimpan entri dan mengabari pendengar', () {
      final aliran = DebugLog.saya.aliran;
      var perubahan = 0;
      void hitung() => perubahan++;
      aliran.addListener(hitung);

      DebugLog.saya.tulis('pesan pertama');
      DebugLog.saya.tulis('pesan kedua');

      expect(perubahan, 2);
      expect(DebugLog.saya.entri, hasLength(2));
      expect(DebugLog.saya.entri.first, contains('pesan pertama'));
      expect(DebugLog.saya.jumlahGalat, 0);

      DebugLog.saya.tulis('✗ ini galat');
      expect(DebugLog.saya.jumlahGalat, 1);

      aliran.removeListener(hitung);
    });

    test('bersihkan mengosongkan entri', () {
      DebugLog.saya.tulis('isi');
      DebugLog.saya.bersihkan();
      expect(DebugLog.saya.entri, isEmpty);
      expect(DebugLog.saya.jumlahGalat, 0);
    });
  });

  group('OnboardingController.simpan', () {
    test('menandai sudah_instal meski notifikasi WA gagal', () async {
      SharedPreferences.setMockInitialValues({});
      final preferensi = LayananPreferensi(
        await SharedPreferences.getInstance(),
      );
      final fonnte = LayananFonnte(
        MockClient(
          (_) async => http.Response(
            '{"Status": false, "reason": "nomor tidak terdaftar"}',
            200,
          ),
        ),
      );

      final kontroller = OnboardingController(
        layananPreferensi: preferensi,
        layananFonnte: fonnte,
      )
        ..namaController.text = 'Budi Santoso'
        ..nomorController.text = '085849910396';

      final berhasil = await kontroller.simpan();

      expect(berhasil, isTrue);
      expect(preferensi.sudahInstal, isTrue);
      expect(preferensi.namaPengguna, 'Budi Santoso');
      expect(preferensi.nomorPengguna, '6285849910396');

      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(
        DebugLog.saya.entri.any(
          (e) => e.contains('WA "balasan ke pengguna" GAGAL'),
        ),
        isTrue,
        reason: 'galat kirim WA harus tercatat di konsol debug',
      );

      kontroller.dispose();
    });

    test('menolak nomor tidak valid tanpa menandai terpasang', () async {
      SharedPreferences.setMockInitialValues({});
      final preferensi = LayananPreferensi(
        await SharedPreferences.getInstance(),
      );
      final kontroller = OnboardingController(
        layananPreferensi: preferensi,
        layananFonnte: LayananFonnte(),
      )
        ..namaController.text = 'Budi'
        ..nomorController.text = 'abcd1234';

      final berhasil = await kontroller.simpan();

      expect(berhasil, isFalse);
      expect(preferensi.sudahInstal, isFalse);
      expect(
        DebugLog.saya.entri.any((e) => e.contains('Validasi gagal')),
        isTrue,
      );

      kontroller.dispose();
    });

    test('normalisasi mengubah awalan 0 menjadi 62', () async {
      SharedPreferences.setMockInitialValues({});
      final preferensi = LayananPreferensi(
        await SharedPreferences.getInstance(),
      );
      final kontroller = OnboardingController(
        layananPreferensi: preferensi,
        layananFonnte: LayananFonnte(),
      );

      final nomor = kontroller.normalisasiNomor('085849910396');
      expect(nomor, '6285849910396');

      kontroller.dispose();
    });
  });
}