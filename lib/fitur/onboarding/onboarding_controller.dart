import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/layanan_fonnte.dart';
import '../../core/services/layanan_preferensi.dart';
import '../../komponen/debug/log_debug.dart';
import '../../komponen/snackbar/snackbar_dompetku.dart';

class OnboardingController extends GetxController {
  final LayananPreferensi layananPreferensi;
  final LayananFonnte layananFonnte;

  final namaController = TextEditingController();
  final nomorController = TextEditingController();

  final menyimpan = false.obs;
  final galat = RxnString();

  OnboardingController({
    required this.layananPreferensi,
    required this.layananFonnte,
  });

  bool get sudahInstal => layananPreferensi.sudahInstal;

  /// Menyimpan profil tanpa mengirim pesan
  /// (jalur bypass khusus pengembang).
  Future<void> lewati() async {
    DebugLog.saya.tulis(
      '≡ Lewati onboarding tanpa notifikasi.',
    );

    await layananPreferensi.tandaiSudahInstal();

    DebugLog.saya.tulis(
      '✓ Profil ditandai terpasang via lewati.',
    );
  }

  Future<bool> simpan() async {
    debugPrint('>>> MASUK FUNGSI SIMPAN() <<<');
    galat.value = null;

    final nama = namaController.text.trim();
    final masukanNomor = nomorController.text.trim();

    debugPrint('>>> Input: Nama="$nama", Nomor="$masukanNomor"');

    if (nama.isEmpty) {
      galat.value = 'Nama asli tidak boleh kosong.';
      debugPrint('>>> GAGAL: Nama kosong');
      return false;
    }

    final nomor = normalisasiNomor(masukanNomor);
    if (nomor == null) {
      galat.value = 'Nomor WhatsApp tidak valid. Contoh: 081234567890';
      debugPrint('>>> GAGAL: Nomor tidak valid');
      return false;
    }

    if (menyimpan.value) {
      debugPrint('>>> GAGAL: Sedang memproses (mencegah double klik)');
      return false;
    }

    menyimpan.value = true;

    try {
      // 1. KIRIM NOTIFIKASI WA LEBIH DULU!
      // Agar tidak ter-kill jika aplikasi mendadak pindah halaman
      debugPrint('>>> Memulai proses kirim notifikasi WA...');
      await _kirimNotifikasi(nama, nomor);
      debugPrint('>>> Selesai proses notifikasi WA!');

      // 2. BARU SIMPAN KE PREFERENSI LOKAL
      // Jika kode ini memicu GetX pindah halaman otomatis, tidak masalah
      // karena pesan WA sudah dipastikan aman terkirim.
      debugPrint('>>> Menyimpan profil ke preferensi lokal...');
      await layananPreferensi.simpanProfil(
        nama: nama,
        nomor: nomor,
      );
      debugPrint('>>> Profil berhasil disimpan!');

      return true;
    } catch (galatSimpan, jejak) {
      debugPrint('>>> EXCEPTION saat simpan: $galatSimpan\n$jejak');
      galat.value = 'Gagal menyimpan profil. Silakan coba lagi.';
      return false;
    } finally {
      menyimpan.value = false;
      debugPrint('>>> KELUAR FUNGSI SIMPAN() <<<');
    }
  }

  Future<void> _kirimNotifikasi(
    String nama,
    String nomor,
  ) async {
    try {
      // 1. Kirim ke WA pengembang
      await _kirimKeFonnte(
        label: 'ke pengembang',
        target: LayananFonnte.nomorWaPengembang,
        isi: 'Halo, ada pengguna baru! 🎉\n\n'
             '$nama baru menginstall dan mulai menggunakan '
             'aplikasi DompetKu.\n\n'
             'Nomor WhatsApp: $nomor',
      );

      // 2. Jeda 2 detik agar Fonnte memproses request pertama dengan aman
      await Future.delayed(const Duration(seconds: 2));

      // 3. Kirim ke WA pengguna
      await _kirimKeFonnte(
        label: 'balasan ke pengguna',
        target: nomor,
        isi: 'Terima kasih $nama! 🎉\n\n'
             'Kamu resmi terdaftar sebagai pengguna DompetKu. '
             'Aplikasi ini membantumu mencatat pemasukan, '
             'pengeluaran, transfer, dan piutang secara mudah '
             'dan offline.\n\n'
             'Selamat mencatat! 💚',
      );
    } catch (galatTakDugaan, jejak) {
      DebugLog.saya.tulis(
        '✗ Galat tak terduga saat kirim WA:\n'
        '$galatTakDugaan\n$jejak',
      );
    }
  }

  Future<void> _kirimKeFonnte({
    required String label,
    required String target,
    required String isi,
  }) async {
    final targetBersih = target.trim();
    final mulai = DateTime.now();

    // Tambahkan debugPrint agar tampil di terminal
    debugPrint('=== PROSES FONNTE ===');
    debugPrint('Kirim WA "$label" -> "$targetBersih" ...');
    
    // Log asli tetap dipertahankan
    DebugLog.saya.tulis(
      '≡ Kirim WA "$label" → "$targetBersih" ...',
    );

    if (targetBersih.isEmpty) {
      debugPrint('✗ GAGAL: Nomor tujuan kosong.');
      DebugLog.saya.tulis(
        '✗ WA "$label" GAGAL: nomor tujuan pengembang kosong.',
      );
      _infoNotifikasiGagal('Nomor tujuan WhatsApp kosong.');
      return;
    }

    try {
      final hasil = await layananFonnte.kirim(
        target: targetBersih,
        pesan: isi,
      );

      final durasi = DateTime.now().difference(mulai).inMilliseconds;

      if (hasil.berhasil) {
        debugPrint('✓ BERHASIL ($durasi ms): WA "$label" terkirim!');
        if (hasil.detail != null) debugPrint('Detail Respons: ${hasil.detail}');
        
        DebugLog.saya.tulis(
          '✓ WA "$label" terkirim ($durasi ms)'
          '${hasil.detail == null ? '' : ' — ${hasil.detail}'}',
        );
      } else {
        debugPrint('✗ GAGAL ($durasi ms): WA "$label" gagal dikirim!');
        debugPrint('Alasan: ${hasil.alasan}');
        if (hasil.detail != null) debugPrint('Detail Respons: ${hasil.detail}');
        
        DebugLog.saya.tulis(
          '✗ WA "$label" GAGAL ($durasi ms): ${hasil.alasan}'
          '${hasil.detail == null ? '' : ' — ${hasil.detail}'}',
        );
        _infoNotifikasiGagal(hasil.alasan);
      }
    } catch (galat, jejak) {
      final durasi = DateTime.now().difference(mulai).inMilliseconds;
      
      debugPrint('✗ EXCEPTION ($durasi ms): Terjadi galat saat kirim WA "$label"');
      debugPrint(galat.toString());
      
      DebugLog.saya.tulis(
        '✗ WA "$label" EXCEPTION ($durasi ms): $galat\n$jejak',
      );
      _infoNotifikasiGagal('Terjadi kesalahan saat mengirim pesan.');
    }
    debugPrint('=====================');
  }

  void _infoNotifikasiGagal(String? alasan) {
    DebugLog.saya.tulis(
      '⚠ Snackbar peringatan notifikasi ditampilkan.',
    );

    final konteksOverlay = _konteksOverlayAman();

    if (konteksOverlay == null) {
      return;
    }

    try {
      tampilkanSnackbarDompetku(
        jenis: JenisSnackbar.peringatan,
        judul: 'Notifikasi WhatsApp',
        pesan:
            'Profil sudah tersimpan, tetapi notifikasi '
            'WhatsApp belum terkirim'
            '${alasan == null ? '.' : ': $alasan.'} '
            'Kamu tetap bisa memakai DompetKu.',
      );
    } catch (_) {
      // Kegagalan menampilkan snackbar tidak boleh
      // merusak alur penyimpanan.
    }
  }

  BuildContext? _konteksOverlayAman() {
    try {
      return Get.overlayContext;
    } catch (_) {
      return null;
    }
  }

  /// Mengembalikan nomor dalam format internasional (62xx),
  /// atau null bila tidak valid.
  String? normalisasiNomor(String masukan) {
    final angka = masukan.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (angka.length < 10 || angka.length > 15) {
      return null;
    }

    if (angka.startsWith('0')) {
      return '62${angka.substring(1)}';
    }

    if (angka.startsWith('62')) {
      return angka;
    }

    return null;
  }

  @override
  void onClose() {
    namaController.dispose();
    nomorController.dispose();
    super.onClose();
  }
}