import '../../../data/model/enum_dompetku.dart';

/// Menebak jenis transaksi (pemasukan/pengeluaran) dari teks mentah.
///
/// Bila [namaPemilik] diisi dan ada baris yang persis sama dengan nama itu
/// pada teks berlabel "penerima", transaksi dianggap pemasukan (transfer ke
/// diri sendiri / dana masuk ke akun pengguna).
JenisTransaksi deteksiJenisDariTeks(String teks, {String? namaPemilik}) {
  final t = teks.toLowerCase();

  // Transfer yang penerimanya adalah pemilik akun = dana masuk
  final pemilik = namaPemilik?.trim().toLowerCase();
  if (pemilik != null && pemilik.isNotEmpty && t.contains('penerima')) {
    final adaBarisNamaPemilik = t.split('\n').any((b) => b.trim() == pemilik);
    if (adaBarisNamaPemilik) return JenisTransaksi.pemasukan;
  }

  // Indikator kuat Pemasukan (Dana masuk ke akun pengguna)
  const indikatorMasuk = [
    'pembayaran diterima',
    'dana diterima',
    'berhasil dikirim ke', // jika konteksnya uang masuk dari orang lain
    'kredit',
    'credited',
    'top up e-wallet',
  ];

  for (final kata in indikatorMasuk) {
    if (t.contains(kata)) return JenisTransaksi.pemasukan;
  }

  // Cek pola baris "Ke" vs "Dari" secara dinamis
  // Jika teks menyatakan transfer "dari" seseorang/suatu sumber ke akun pemilik, atau "penerima" orang lain.
  // Biasanya jika ada label "Dari:" yang bukan nama pemilik, atau "Ke:" yang tujuannya ke pihak luar.
  // Namun, pendekatan paling aman pada bukti transfer:
  if (t.contains('pembayaran diterima') || t.contains('diterima oleh')) {
    return JenisTransaksi.pemasukan;
  }

  // Deteksi kata kunci umum pengeluaran
  const indikatorKeluar = [
    'pengeluaran',
    'pembayaran',
    'dibayar',
    'terkirim',
    'debit',
    'purchase',
    'payment',
  ];

  for (final kata in indikatorKeluar) {
    if (t.contains(kata)) return JenisTransaksi.pengeluaran;
  }

  return JenisTransaksi.pengeluaran; // Default aman
}
