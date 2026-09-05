import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositori/repositori_piutang.dart';

class FormPiutangController extends GetxController {
  final RepositoriPiutang repositoriPiutang;

  final namaController = TextEditingController();
  final catatanController = TextEditingController();
  final menyimpan = false.obs;
  final galat = RxnString();

  FormPiutangController({required this.repositoriPiutang});

  Future<bool> simpan() async {
    galat.value = null;

    final nama = namaController.text.trim();
    if (nama.isEmpty) {
      galat.value = 'Nama orang tidak boleh kosong.';
      return false;
    }
    if (menyimpan.value) return false;

    menyimpan.value = true;
    try {
      final catatan = catatanController.text.trim();
      await repositoriPiutang.buatPiutang(
        nama: nama,
        catatan: catatan.isEmpty ? null : catatan,
      );
      return true;
    } catch (_) {
      galat.value = 'Gagal menyimpan piutang. Silakan coba lagi.';
      return false;
    } finally {
      menyimpan.value = false;
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    catatanController.dispose();
    super.onClose();
  }
}