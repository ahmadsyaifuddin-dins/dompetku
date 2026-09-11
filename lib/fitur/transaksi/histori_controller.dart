import 'package:get/get.dart';

import '../../data/model/ringkasan_entri.dart';
import '../../core/services/layanan_saldo.dart';

List<EntriHistori> saringHistori(
  List<EntriHistori> histori, {
  JenisEntri? jenis,
  String? kategoriId,
  String? akunDanaId,
  DateTime? tanggalAwal,
  DateTime? tanggalAkhir,
}) {
  Iterable<EntriHistori> hasil = histori;
  if (jenis != null) {
    hasil = hasil.where((entri) => entri.jenis == jenis);
  }
  if (kategoriId != null) {
    hasil = hasil.where((entri) => entri.kategoriId == kategoriId);
  }
  if (akunDanaId != null) {
    hasil = hasil.where((entri) => entri.akunDanaId == akunDanaId);
  }
  if (tanggalAwal != null) {
    hasil = hasil.where((entri) => !entri.tanggal.isBefore(tanggalAwal));
  }
  if (tanggalAkhir != null) {
    final batas = DateTime(
      tanggalAkhir.year,
      tanggalAkhir.month,
      tanggalAkhir.day,
      23,
      59,
      59,
    );
    hasil = hasil.where((entri) => !entri.tanggal.isAfter(batas));
  }
  return hasil.toList();
}

class HistoriController extends GetxController {
  final LayananSaldo layananSaldo;
  final filter = Rxn<JenisEntri>();
  final kategori = Rxn<String>();
  final akun = Rxn<String>();
  final tanggalAwal = Rxn<DateTime>();
  final tanggalAkhir = Rxn<DateTime>();

  HistoriController({required this.layananSaldo});

  bool get punyaFilter =>
      filter.value != null ||
      kategori.value != null ||
      akun.value != null ||
      tanggalAwal.value != null ||
      tanggalAkhir.value != null;

  void resetKriteria() {
    filter.value = null;
    kategori.value = null;
    akun.value = null;
    tanggalAwal.value = null;
    tanggalAkhir.value = null;
  }

  List<EntriHistori> get histori => saringHistori(
        layananSaldo.histori,
        jenis: filter.value,
        kategoriId: kategori.value,
        akunDanaId: akun.value,
        tanggalAwal: tanggalAwal.value,
        tanggalAkhir: tanggalAkhir.value,
      );
}