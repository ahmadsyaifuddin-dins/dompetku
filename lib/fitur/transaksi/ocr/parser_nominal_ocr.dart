/// Baca nominal dari teks mentah, misal "Rp 75.000,00", "Rp75.000",
/// "IDR 1,100,000.00", atau "1.500.000" (berpenanda titik ribuan).
///
/// Mengabaikan komponen desimal (",00" atau ".00") karena rupiah tidak
/// memakai pecahan sen di aplikasi ini. Saat ada beberapa nilai (misal saldo
/// + total), nilai pada baris berisi "total/bayar/transfer/nominal" lebih
/// diutamakan, lalu nilai terbesar. Nominal pada baris biaya/admin diabaikan.
int? parseNominalOCR(String teks) {
  var kandidat = _kumpulkanNominal(teks, harusBerawalanRp: true);
  if (kandidat.isEmpty) {
    kandidat = _kumpulkanNominal(teks, harusBerawalanRp: false);
  }
  if (kandidat.isEmpty) return null;

  final tanpaSaldo = kandidat
      .where((k) => !k.nilaiTerkontekstual.toLowerCase().contains('saldo'))
      .toList();
  final kumpulanAwal = tanpaSaldo.isEmpty ? kandidat : tanpaSaldo;

  // Buang nominal yang ada di baris biaya/admin (cek baris sendiri saja,
  // bukan baris tetangga, supaya "Nominal" di atas "Biaya" tidak ikut terbuang).
  final tanpaBiaya = kumpulanAwal.where((k) {
    final b = k.barisIni.toLowerCase();
    return !(b.contains('biaya') || b.contains('admin') || b.contains('fee'));
  }).toList();
  final kumpulan = tanpaBiaya.isEmpty ? kumpulanAwal : tanpaBiaya;

  final denganKunci = kumpulan.where((k) {
    final b = k.nilaiTerkontekstual.toLowerCase();
    return b.contains('total') ||
        b.contains('bayar') ||
        b.contains('transfer') ||
        b.contains('nominal') ||
        b.contains('transaksi') ||
        b.contains('nilai') ||
        b.contains('jumlah');
  }).toList();
  final pilihan = denganKunci.isEmpty ? kumpulan : denganKunci;

  pilihan.sort((a, b) => b.nilai.compareTo(a.nilai));
  return pilihan.first.nilai;
}

class _KandidatNominal {
  final int nilai;
  final String barisIni;
  final String nilaiTerkontekstual;

  _KandidatNominal(this.nilai, this.barisIni, this.nilaiTerkontekstual);
}

List<_KandidatNominal> _kumpulkanNominal(
  String teks, {
  required bool harusBerawalanRp,
}) {
  final hasil = <_KandidatNominal>[];
  final pola = harusBerawalanRp
      ? RegExp(r'(?:Rp|IDR)[.\s:]*([\d.,]+)', caseSensitive: false)
      : RegExp(r'(?<!\d)\d{1,3}(?:[.,]\d{3})+(?:[.,]\d{1,2})?(?!\d)');

  final baris = teks.split('\n');
  for (var i = 0; i < baris.length; i++) {
    final barisIni = baris[i];
    for (final cocok in pola.allMatches(barisIni)) {
      final nilai = _bersihkanNominal(
        harusBerawalanRp ? cocok.group(1)! : cocok.group(0)!,
      );
      if (nilai == null || nilai <= 0) continue;
      final sebelumnya = i > 0 ? '${baris[i - 1]} ' : '';
      final berikutnya = i + 1 < baris.length ? ' ${baris[i + 1]}' : '';
      hasil.add(
        _KandidatNominal(nilai, barisIni, '$sebelumnya$barisIni$berikutnya'),
      );
    }
  }
  return hasil;
}

int? _bersihkanNominal(String teks) {
  // Hapus awalan IDR atau Rp jika masih tertinggal
  var s = teks.replaceAll(RegExp(r'^(?:Rp|IDR)\s*', caseSensitive: false), '');
  // Buang tanda baca sisa di ujung (misal "75.000.")
  s = s.replaceAll(RegExp(r'[.,]+$'), '');
  // Buang desimal 1-2 digit, baik ",00" (format Indonesia) maupun ".00" (format Inggris)
  s = s.replaceAll(RegExp(r'[.,]\d{1,2}$'), '');
  // Ambil hanya angka saja, abaikan titik/koma pemisah ribuan
  final angka = s.replaceAll(RegExp(r'[^0-9]'), '');
  if (angka.isEmpty) return null;
  final nilai = int.tryParse(angka);
  return nilai == null ? null : (nilai > 0 ? nilai : null);
}
