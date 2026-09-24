import 'draft_transaksi_ocr_model.dart';
import 'ekstrak_draft_ocr.dart';

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
