import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../data/repositori/repositori_akun_dana.dart';
import '../../inti/layanan/layanan_saldo.dart';
import '../../inti/utilitas/format_rupiah.dart';

class AkunDanaController extends GetxController {
  final RepositoriAkunDana repositori;
  final LayananSaldo layananSaldo;

  final semuaAkun = <AkunDanaData>[].obs;
  final namaController = TextEditingController();
  final saldoAwalController = TextEditingController();
  final jenis = JenisAkun.bank.obs;
  final menyimpan = false.obs;
  final galat = RxnString();

  AkunDanaController({
    required this.repositori,
    required this.layananSaldo,
  });

  List<AkunDanaData> get akunAktif {
    return semuaAkun.where((akun) => akun.aktif).toList();
  }

  List<AkunDanaData> get akunNonaktif {
    return semuaAkun.where((akun) => !akun.aktif).toList();
  }

  int? saldoUntuk(String id) => layananSaldo.saldoPerAkun[id];

  int get saldoAwal {
    final teks = saldoAwalController.text;
    return parseNominalInput(teks) ?? 0;
  }

  @override
  void onInit() {
    super.onInit();
    repositori.pantauSemua().listen((data) {
      semuaAkun.value = data;
    });
  }

  @override
  void onClose() {
    namaController.dispose();
    saldoAwalController.dispose();
    super.onClose();
  }

  Future<bool> tambah({
    required String nama,
    required JenisAkun jenis,
    int saldoAwal = 0,
  }) async {
    galat.value = null;
    final bersih = nama.trim();
    if (bersih.isEmpty) {
      galat.value = 'Nama akun tidak boleh kosong.';
      return false;
    }
    if (menyimpan.value) return false;

    menyimpan.value = true;
    try {
      await repositori.buat(
        nama: bersih,
        jenis: jenis,
        saldoAwal: saldoAwal,
      );
      return true;
    } catch (_) {
      galat.value = 'Gagal menyimpan akun dana. Silakan coba lagi.';
      return false;
    } finally {
      menyimpan.value = false;
    }
  }

  Future<bool> perbaruiNama(AkunDanaData akun, String namaBaru) async {
    galat.value = null;
    final bersih = namaBaru.trim();
    if (bersih.isEmpty) {
      galat.value = 'Nama akun tidak boleh kosong.';
      return false;
    }
    if (bersih == akun.nama) return true;
    if (menyimpan.value) return false;

    menyimpan.value = true;
    try {
      await repositori.perbaruiNama(akun.id, bersih);
      return true;
    } catch (_) {
      galat.value = 'Gagal memperbarui nama akun. Silakan coba lagi.';
      return false;
    } finally {
      menyimpan.value = false;
    }
  }

  Future<bool> nonaktifkan(AkunDanaData akun) async {
    if (menyimpan.value) return false;
    menyimpan.value = true;
    try {
      await repositori.nonaktifkan(akun.id);
      return true;
    } catch (_) {
      galat.value = 'Gagal menonaktifkan akun. Silakan coba lagi.';
      return false;
    } finally {
      menyimpan.value = false;
    }
  }
}