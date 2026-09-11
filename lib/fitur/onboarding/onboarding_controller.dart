import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/layanan_fonnte.dart';
import '../../core/services/layanan_preferensi.dart';

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

  /// Menyimpan profil tanpa mengirim pesan (jalur bypass khusus pengembang).
  Future<void> lewati() async {
    await layananPreferensi.tandaiSudahInstal();
  }

  Future<bool> simpan() async {
    galat.value = null;

    final nama = namaController.text.trim();
    if (nama.isEmpty) {
      galat.value = 'Nama asli tidak boleh kosong.';
      return false;
    }

    final nomor = _normalisasiNomor(nomorController.text);
    if (nomor == null) {
      galat.value = 'Nomor WhatsApp tidak valid. '
          'Contoh: 081234567890 atau 6281234567890.';
      return false;
    }
    if (menyimpan.value) return false;

    menyimpan.value = true;
    try {
      await layananPreferensi.simpanProfil(nama: nama, nomor: nomor);
      await _kirimNotifikasi(nama, nomor);
      return true;
    } catch (_) {
      galat.value = 'Gagal menyimpan profil. Silakan coba lagi.';
      return false;
    } finally {
      menyimpan.value = false;
    }
  }

  Future<void> _kirimNotifikasi(String nama, String nomor) async {
    try {
      await Future.wait([
        layananFonnte.kirim(
          target: LayananFonnte.nomorWaPengembang,
          pesan: 'Halo, ada pengguna baru! 🎉\n\n'
              '$nama baru menginstall dan mulai menggunakan '
              'aplikasi DompetKu.\n\n'
              'Nomor WhatsApp: $nomor',
        ),
        layananFonnte.kirim(
          target: nomor,
          pesan: 'Terima kasih $nama! 🎉\n\n'
              'Kamu resmi terdaftar sebagai pengguna DompetKu. '
              'Aplikasi ini membantumu mencatat pemasukan, pengeluaran, '
              'transfer, dan piutang secara mudah dan offline.\n\n'
              'Selamat mencatat! 💚',
        ),
      ]);
    } catch (_) {
      // Gagal mengirim notifikasi tidak menghalangi pengguna melanjutkan.
    }
  }

  /// Mengembalikan nomor dalam format internasional (62xx), atau null
  /// bila tidak valid.
  String? _normalisasiNomor(String masukan) {
    final angka = masukan.replaceAll(RegExp(r'[^0-9]'), '');
    if (angka.length < 10 || angka.length > 15) return null;
    if (angka.startsWith('0')) return '62${angka.substring(1)}';
    if (angka.startsWith('62')) return angka;
    return null;
  }

  @override
  void onClose() {
    namaController.dispose();
    nomorController.dispose();
    super.onClose();
  }
}