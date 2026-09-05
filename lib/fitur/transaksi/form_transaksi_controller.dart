import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../data/repositori/repositori_akun_dana.dart';
import '../../data/repositori/repositori_kategori.dart';
import '../../data/repositori/repositori_transaksi.dart';
import '../../inti/utilitas/format_rupiah.dart';
import '../../inti/validasi/validasi_transaksi.dart';

class FormTransaksiController extends GetxController {
  final RepositoriTransaksi repositoriTransaksi;
  final RepositoriAkunDana repositoriAkunDana;
  final RepositoriKategori repositoriKategori;

  final JenisTransaksi jenis;
  final TransaksiData? sedangMengedit;
  final nominalController = TextEditingController();
  final catatanController = TextEditingController();
  final akunId = RxnString();
  final kategoriId = RxnString();
  final tanggal = DateTime.now().obs;
  final menyimpan = false.obs;
  final galat = RxnString();

  final opsiAkun = <AkunDanaData>[].obs;
  final opsiKategori = <KategoriData>[].obs;

  StreamSubscription<List<AkunDanaData>>? _langgananAkun;
  StreamSubscription<List<KategoriData>>? _langgananKategori;

  FormTransaksiController({
    required this.jenis,
    required this.repositoriTransaksi,
    required this.repositoriAkunDana,
    required this.repositoriKategori,
    TransaksiData? sedangMengedit,
  }) : sedangMengedit = sedangMengedit {
    if (sedangMengedit != null) {
      nominalController.text = formatNominalInput(
        sedangMengedit.nominal.toString(),
      );
      akunId.value = sedangMengedit.akunDanaId;
      kategoriId.value = sedangMengedit.kategoriId;
      tanggal.value = sedangMengedit.tanggal;
      catatanController.text = sedangMengedit.catatan ?? '';
    }
  }

  bool get sedangEdit => sedangMengedit != null;

  @override
  void onInit() {
    super.onInit();
    _langgananAkun = repositoriAkunDana.pantauSemuaAktif().listen((data) {
      opsiAkun.value = data;
      if (akunId.value == null && data.isNotEmpty) {
        akunId.value = data.first.id;
      }
    });
    _langgananKategori = repositoriKategori
        .pantauAktif(jenis: jenis)
        .listen((data) {
      opsiKategori.value = data;
    });
  }

  int? get nominal => parseNominalInput(nominalController.text);

  Future<bool> simpan() async {
    galat.value = null;

    final galatNominal = validasiNominal(nominal);
    if (galatNominal != null) {
      galat.value = galatNominal;
      return false;
    }
    if (akunId.value == null) {
      galat.value = 'Pilih akun dana.';
      return false;
    }
    if (kategoriId.value == null) {
      galat.value = 'Pilih kategori.';
      return false;
    }
    if (menyimpan.value) return false;

    menyimpan.value = true;
    try {
      final catatan = catatanController.text.trim();
      final catatanAkhir = catatan.isEmpty ? null : catatan;
      if (sedangEdit) {
        await repositoriTransaksi.perbarui(
          id: sedangMengedit!.id,
          akunDanaId: akunId.value!,
          kategoriId: kategoriId.value,
          jenis: jenis,
          nominal: nominal!,
          tanggal: tanggal.value,
          catatan: catatanAkhir,
        );
      } else {
        await repositoriTransaksi.tambah(
          akunDanaId: akunId.value!,
          kategoriId: kategoriId.value,
          jenis: jenis,
          nominal: nominal!,
          tanggal: tanggal.value,
          catatan: catatanAkhir,
        );
      }
      return true;
    } catch (_) {
      galat.value = 'Gagal menyimpan transaksi. Silakan coba lagi.';
      return false;
    } finally {
      menyimpan.value = false;
    }
  }

  @override
  void onClose() {
    nominalController.dispose();
    catatanController.dispose();
    _langgananAkun?.cancel();
    _langgananKategori?.cancel();
    super.onClose();
  }
}