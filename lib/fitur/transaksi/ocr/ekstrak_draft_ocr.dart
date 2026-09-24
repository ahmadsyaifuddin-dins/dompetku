import '../../../core/utils/format_rupiah.dart';
import '../../../data/model/enum_dompetku.dart';
import 'draft_transaksi_ocr_model.dart';
import 'parser_jenis_ocr.dart';
import 'parser_merchant_ocr.dart';
import 'parser_metode_ocr.dart';
import 'parser_nominal_ocr.dart';
import 'parser_tanggal_ocr.dart';

/// Titik masuk OCR -> parser -> draft.
///
/// Mengenali teks berformat "Kunci: Nilai" (struktur keluar Dompetku) maupun
/// teks mentah hasil mesin OCR, misal tangkapan layar notifikasi bank atau
/// e-wallet. Nilai hasil OCR hanya menjadi sampel; pengguna mengoreksinya di
/// layar tinjauan (PRD 15.4).
///
/// Mengembalikan null bila nominal tidak terbaca dan [wajibNominal] aktif.
/// Atur [wajibNominal] ke false untuk tetap melengkapi di layar tinjauan.
///
/// [namaPemilik] (opsional) membantu mendeteksi pemasukan saat penerima
/// transfer adalah pengguna sendiri.
DraftTransaksiOCR? ekstrakDraftDariTeks(
  String teks, {
  bool wajibNominal = true,
  String? namaPemilik,
}) {
  final baris = teks
      .split('\n')
      .map((b) => b.trim())
      .where((b) => b.isNotEmpty)
      .toList();

  var jenis = deteksiJenisDariTeks(teks, namaPemilik: namaPemilik);
  var nominal = 0;
  var tanggal = DateTime.now();
  String? merchant;
  String? metode;
  String? catatan;

  for (final token in baris) {
    final pisah = token.indexOf(':');
    if (pisah < 0) continue;
    final kunci = token.substring(0, pisah).trim().toLowerCase();
    final nilai = token.substring(pisah + 1).trim();
    if (nilai.isEmpty) continue;

    switch (kunci) {
      case 'jenis':
        jenis = nilai.toLowerCase().contains('pemasukan')
            ? JenisTransaksi.pemasukan
            : JenisTransaksi.pengeluaran;
        break;
      case 'nominal':
        nominal = parseNominalInput(nilai) ?? nominal;
        break;
      case 'tanggal' || 'tgl' || 'date' || 'waktu':
        tanggal = parseTanggalOCR(nilai) ?? tanggal;
        break;
      case 'merchant' || 'penerima' || 'toko' || 'nama':
        merchant = nilai;
        break;
      case 'metode' || 'metode pembayaran' || 'akun':
        metode = nilai;
        break;
      case 'catatan' || 'keterangan':
        catatan = nilai;
        break;
    }
  }

  if (nominal <= 0) nominal = parseNominalOCR(teks) ?? 0;
  merchant ??= cariMerchantDariTeks(baris);
  metode ??= cariMetodeDariTeks(baris);
  final dariTanggal = cariTanggalDariTeks(baris);
  if (dariTanggal != null) tanggal = dariTanggal;

  if (wajibNominal && nominal <= 0) return null;

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

/// Draft dari teks mentah yang selalu dibuat (nominal boleh kosong) agar
/// pengguna tetap bisa melengkapi di layar tinjauan, mis. saat teks terbaca
/// namun nominalnya tidak terdeteksi.
DraftTransaksiOCR buatDraftTeksMentah(String teks, {String? namaPemilik}) {
  final terurai = ekstrakDraftDariTeks(
    teks,
    wajibNominal: false,
    namaPemilik: namaPemilik,
  );
  if (terurai != null) return terurai;
  return DraftTransaksiOCR(
    jenis: JenisTransaksi.pengeluaran,
    nominal: 0,
    tanggal: DateTime.now(),
    teksMentah: teks.trim(),
  );
}
