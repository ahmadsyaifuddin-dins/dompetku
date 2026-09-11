import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/repositori/repositori_akun_dana.dart';
import '../../data/repositori/repositori_transfer.dart';
import '../../core/utils/format_rupiah.dart';
import '../../core/validation/validasi_transaksi.dart';

class FormTransferController extends GetxController {
  final RepositoriTransfer repositoriTransfer;
  final RepositoriAkunDana repositoriAkunDana;

  final TransferData? sedangMengedit;
  final nominalController = TextEditingController();
  final catatanController = TextEditingController();
  final akunAsalId = RxnString();
  final akunTujuanId = RxnString();
  final tanggal = DateTime.now().obs;
  final menyimpan = false.obs;
  final galat = RxnString();

  final opsiAkun = <AkunDanaData>[].obs;

  StreamSubscription<List<AkunDanaData>>? _langgananAkun;

  FormTransferController({
    required this.repositoriTransfer,
    required this.repositoriAkunDana,
    TransferData? sedangMengedit,
  }) : sedangMengedit = sedangMengedit {
    if (sedangMengedit != null) {
      nominalController.text = formatNominalInput(
        sedangMengedit.nominal.toString(),
      );
      akunAsalId.value = sedangMengedit.akunAsalId;
      akunTujuanId.value = sedangMengedit.akunTujuanId;
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
      if (akunAsalId.value == null && data.isNotEmpty) {
        akunAsalId.value = data.first.id;
      }
      if (akunTujuanId.value == null && data.length > 1) {
        akunTujuanId.value = data[1].id;
      }
    });
  }

  int? get nominal => parseNominalInput(nominalController.text);

  AkunDanaData? get akunAsal {
    final id = akunAsalId.value;
    if (id == null) return null;
    return opsiAkun.where((a) => a.id == id).firstOrNull;
  }

  AkunDanaData? get akunTujuan {
    final id = akunTujuanId.value;
    if (id == null) return null;
    return opsiAkun.where((a) => a.id == id).firstOrNull;
  }

  Future<bool> simpan() async {
    galat.value = null;

    final galatTransfer = validasiTransfer(
      akunAsal: akunAsal,
      akunTujuan: akunTujuan,
      nominal: nominal,
    );
    if (galatTransfer != null) {
      galat.value = galatTransfer;
      return false;
    }
    if (menyimpan.value) return false;

    menyimpan.value = true;
    try {
      final catatan = catatanController.text.trim();
      final catatanAkhir = catatan.isEmpty ? null : catatan;
      if (sedangEdit) {
        await repositoriTransfer.perbarui(
          id: sedangMengedit!.id,
          akunAsalId: akunAsalId.value!,
          akunTujuanId: akunTujuanId.value!,
          nominal: nominal!,
          tanggal: tanggal.value,
          catatan: catatanAkhir,
        );
      } else {
        await repositoriTransfer.tambah(
          akunAsalId: akunAsalId.value!,
          akunTujuanId: akunTujuanId.value!,
          nominal: nominal!,
          tanggal: tanggal.value,
          catatan: catatanAkhir,
        );
      }
      return true;
    } catch (_) {
      galat.value = 'Gagal menyimpan transfer. Silakan coba lagi.';
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
    super.onClose();
  }
}