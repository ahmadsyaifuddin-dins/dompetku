import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../data/repositori/repositori_kategori.dart';
import '../../core/services/layanan_preferensi.dart';

class KategoriController extends GetxController {
  final RepositoriKategori repositori;
  final LayananPreferensi layananPreferensi;

  final semuaKategori = <KategoriData>[].obs;
  final tab = JenisTransaksi.pengeluaran.obs;
  final bawaanPemasukan = RxnString();
  final bawaanPengeluaran = RxnString();
  final namaController = TextEditingController();
  final ikon = RxnString();
  final menyimpan = false.obs;
  final galat = RxnString();

  KategoriController({
    required this.repositori,
    required this.layananPreferensi,
  });

  List<KategoriData> untuk(JenisTransaksi jenis) {
    return semuaKategori.where((k) => k.jenis == jenis).toList();
  }

  List<KategoriData> aktifUntuk(JenisTransaksi jenis) {
    return semuaKategori
        .where((k) => k.jenis == jenis && k.aktif)
        .toList();
  }

  String? bawaanUntuk(JenisTransaksi jenis) {
    return jenis == JenisTransaksi.pemasukan
        ? bawaanPemasukan.value
        : bawaanPengeluaran.value;
  }

  @override
  void onInit() {
    super.onInit();
    bawaanPemasukan.value =
        layananPreferensi.ambilKategoriBawaan(JenisTransaksi.pemasukan);
    bawaanPengeluaran.value =
        layananPreferensi.ambilKategoriBawaan(JenisTransaksi.pengeluaran);
    repositori.pantauSemua().listen((data) {
      semuaKategori.value = data;
    });
  }

  Future<bool> aturBawaan(KategoriData kategori) async {
    await layananPreferensi.simpanKategoriBawaan(
      kategori.jenis,
      kategori.id,
    );
    if (kategori.jenis == JenisTransaksi.pemasukan) {
      bawaanPemasukan.value = kategori.id;
    } else {
      bawaanPengeluaran.value = kategori.id;
    }
    return true;
  }

  Future<bool> hapusBawaan(JenisTransaksi jenis) async {
    await layananPreferensi.hapusKategoriBawaan(jenis);
    if (jenis == JenisTransaksi.pemasukan) {
      bawaanPemasukan.value = null;
    } else {
      bawaanPengeluaran.value = null;
    }
    return true;
  }

  @override
  void onClose() {
    namaController.dispose();
    super.onClose();
  }

  Future<bool> tambah({
    required JenisTransaksi jenis,
    String? nama,
    String? ikonKunci,
  }) async {
    galat.value = null;
    final bersih = nama?.trim() ?? namaController.text.trim();
    if (bersih.isEmpty) {
      galat.value = 'Nama kategori tidak boleh kosong.';
      return false;
    }
    if (menyimpan.value) return false;

    menyimpan.value = true;
    try {
      await repositori.buat(
        nama: bersih,
        jenis: jenis,
        ikon: ikonKunci,
      );
      return true;
    } catch (_) {
      galat.value = 'Gagal menyimpan kategori. Silakan coba lagi.';
      return false;
    } finally {
      menyimpan.value = false;
    }
  }

  Future<bool> nonaktifkan(KategoriData kategori) async {
    if (menyimpan.value) return false;
    menyimpan.value = true;
    try {
      await repositori.nonaktifkan(kategori.id);
      return true;
    } catch (_) {
      galat.value = 'Gagal menonaktifkan kategori. Silakan coba lagi.';
      return false;
    } finally {
      menyimpan.value = false;
    }
  }

  Future<bool> perbarui(
    KategoriData kategori, {
    String? nama,
    String? ikonKunci,
  }) async {
    galat.value = null;
    final bersih = nama?.trim() ?? namaController.text.trim();
    if (bersih.isEmpty) {
      galat.value = 'Nama kategori tidak boleh kosong.';
      return false;
    }
    if (menyimpan.value) return false;

    menyimpan.value = true;
    try {
      await repositori.perbarui(
        id: kategori.id,
        nama: bersih,
        ikon: ikonKunci,
      );
      return true;
    } catch (_) {
      galat.value = 'Gagal memperbarui kategori. Silakan coba lagi.';
      return false;
    } finally {
      menyimpan.value = false;
    }
  }
}