import 'dart:async';

import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../data/repositori/repositori_piutang.dart';

class DetailPiutangController extends GetxController {
  final RepositoriPiutang repositoriPiutang;

  final PiutangData piutang;
  final riwayat = <RiwayatPiutangData>[].obs;
  final menyimpan = false.obs;
  final galat = RxnString();

  StreamSubscription<List<RiwayatPiutangData>>? _langganan;

  DetailPiutangController({
    required this.repositoriPiutang,
    required this.piutang,
  });

  int get sisa {
    var totalPinjaman = 0;
    var totalPembayaran = 0;
    for (final r in riwayat) {
      switch (r.jenis) {
        case JenisRiwayat.pinjaman:
        case JenisRiwayat.tambahan:
          totalPinjaman += r.nominal;
        case JenisRiwayat.pembayaran:
          totalPembayaran += r.nominal;
      }
    }
    return totalPinjaman - totalPembayaran;
  }

  @override
  void onInit() {
    super.onInit();
    _langganan = repositoriPiutang
        .pantauRiwayat(piutang.id)
        .listen((data) => riwayat.value = data);
  }

  Future<bool> catat({
    required JenisRiwayat jenis,
    required String akunDanaId,
    required int nominal,
    required DateTime tanggal,
    String? catatan,
  }) async {
    galat.value = null;
    if (jenis == JenisRiwayat.pembayaran && nominal > sisa) {
      galat.value = 'Pembayaran melebihi sisa piutang.';
      return false;
    }
    if (menyimpan.value) return false;

    menyimpan.value = true;
    try {
      switch (jenis) {
        case JenisRiwayat.pinjaman:
          await repositoriPiutang.catatPinjaman(
            piutangId: piutang.id,
            akunDanaId: akunDanaId,
            nominal: nominal,
            tanggal: tanggal,
            catatan: catatan,
          );
        case JenisRiwayat.tambahan:
          await repositoriPiutang.catatTambahan(
            piutangId: piutang.id,
            akunDanaId: akunDanaId,
            nominal: nominal,
            tanggal: tanggal,
            catatan: catatan,
          );
        case JenisRiwayat.pembayaran:
          await repositoriPiutang.catatPembayaran(
            piutangId: piutang.id,
            akunDanaId: akunDanaId,
            nominal: nominal,
            tanggal: tanggal,
            catatan: catatan,
          );
      }
      return true;
    } catch (_) {
      galat.value = 'Gagal menyimpan. Silakan coba lagi.';
      return false;
    } finally {
      menyimpan.value = false;
    }
  }

  @override
  void onClose() {
    _langganan?.cancel();
    super.onClose();
  }
}