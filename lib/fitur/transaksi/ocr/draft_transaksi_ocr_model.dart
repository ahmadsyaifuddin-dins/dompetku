import '../../../data/model/enum_dompetku.dart';

/// Draft hasil OCR yang belum menjadi transaksi final.
class DraftTransaksiOCR {
  final JenisTransaksi jenis;
  final int nominal;
  final DateTime tanggal;
  final String? merchant;
  final String? metode;
  final String? akunDanaId;
  final String? kategoriId;
  final String? catatan;
  final String teksMentah;

  const DraftTransaksiOCR({
    required this.jenis,
    required this.nominal,
    required this.tanggal,
    this.merchant,
    this.metode,
    this.akunDanaId,
    this.kategoriId,
    this.catatan,
    required this.teksMentah,
  });
}
