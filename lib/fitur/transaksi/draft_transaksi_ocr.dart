import '../../data/model/enum_dompetku.dart';
import '../../core/utils/format_rupiah.dart';

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

/// Titik masuk OCR -> parser -> draft.
///
/// Saat mesin OCR dikunci (lihat PRD 20), ganti pemanggil fungsi ini dengan
/// hasil teks OCR yang sesungguhnya; pengurai di bawah tetap dipakai.
DraftTransaksiOCR? ekstrakDraftDariTeks(String teks) {
  var jenis = JenisTransaksi.pengeluaran;
  var nominal = 0;
  var tanggal = DateTime.now();
  String? merchant;
  String? metode;
  String? catatan;

  for (final baris in teks.split('\n')) {
    final token = baris.trim();
    if (!token.contains(':')) continue;
    final pisah = token.indexOf(':');
    final kunci = token.substring(0, pisah).trim().toLowerCase();
    final nilai = token.substring(pisah + 1).trim();
    if (nilai.isEmpty) continue;

    switch (kunci) {
      case 'jenis':
        if (nilai.toLowerCase().contains('pemasukan')) {
          jenis = JenisTransaksi.pemasukan;
        }
      case 'nominal':
        nominal = parseNominalInput(nilai) ?? nominal;
      case 'tanggal':
        tanggal = _parseTanggal(nilai) ?? tanggal;
      case 'merchant':
        merchant = nilai;
      case 'metode' || 'metode pembayaran':
        metode = nilai;
      case 'catatan':
        catatan = nilai;
    }
  }

  if (nominal <= 0) return null;

  return DraftTransaksiOCR(
    jenis: jenis,
    nominal: nominal,
    tanggal: tanggal,
    merchant: merchant,
    metode: metode,
    catatan: catatan,
    teksMentah: teks.trim(),
  );
}

const _namaBulan = [
  'januari',
  'februari',
  'maret',
  'april',
  'mei',
  'juni',
  'juli',
  'agustus',
  'september',
  'oktober',
  'november',
  'desember',
];

DateTime? _parseTanggal(String nilai) {
  final iso = DateTime.tryParse(nilai);
  if (iso != null) return iso;

  final bagian = nilai.split(RegExp(r'[/\\\-\. ]+'));
  if (bagian.length == 3) {
    final tahun = int.tryParse(bagian[2]);
    if (tahun != null) {
      final tanggal = int.tryParse(bagian[0]);
      final bulan = int.tryParse(bagian[1]);
      if (tanggal != null && bulan != null && bulan >= 1 && bulan <= 12) {
        return DateTime(tahun, bulan, tanggal);
      }
      final indeksBulan = _namaBulan.indexOf(bagian[1].toLowerCase());
      if (tanggal != null && indeksBulan >= 0) {
        return DateTime(tahun, indeksBulan + 1, tanggal);
      }
    }
  }
  return null;
}

/// Contoh teks yang bentuknya mirip struktur keluar pada PRD 15.3.
const String contohTeksOCR = '''
Jenis: Pengeluaran
Nominal: Rp75.000
Tanggal: 5 September 2026
Merchant: Contoh Merchant
Metode: SeaBank
Catatan: Pembayaran
''';

DraftTransaksiOCR buatDraftContoh() {
  final draft = ekstrakDraftDariTeks(contohTeksOCR);
  assert(draft != null, 'contoh OCR harus selalu terbaca');
  return draft!;
}