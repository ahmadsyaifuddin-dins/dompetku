import 'util_teks_ocr.dart';

const _kataMerchantGarisSama = ['dari'];

const _kataMerchantBarisBerikut = [
  'kepada',
  'penerima',
  'bayar ke',
  'pembayaran ke',
  'untuk',
  'merchant',
  'nama toko',
  'toko',
  'ke',
];

String? cariMerchantDariTeks(List<String> baris) {
  for (var i = 0; i < baris.length; i++) {
    final token = baris[i];
    final pisah = token.indexOf(':');
    if (pisah >= 0) {
      final kunci = token.substring(0, pisah).trim().toLowerCase();
      if (kunci == 'merchant' ||
          kunci == 'penerima' ||
          kunci == 'toko' ||
          kunci == 'nama' ||
          kunci == 'nama toko' ||
          kunci == 'penjual') {
        final nilai = bersihkanNamaOCR(token.substring(pisah + 1));
        if (nilai != null) return nilai;
      }
    }

    for (final kata in _kataMerchantBarisBerikut) {
      final mengandung = RegExp(
        '(?:$kata)\\b',
        caseSensitive: false,
      ).hasMatch(token);
      if (!mengandung) continue;
      final nilai = _nilaiSetelahKata(token, kata);
      if (nilai != null) return nilai;
      if (i + 1 < baris.length) {
        final nilaiBarisBerikut = _nilaiBarisBerikut(baris, i + 1);
        if (nilaiBarisBerikut != null) return nilaiBarisBerikut;
      }
    }

    for (final kata in _kataMerchantGarisSama) {
      final nilai = _nilaiSetelahKata(token, kata);
      if (nilai != null) return nilai;
    }
  }
  return null;
}

String? _nilaiSetelahKata(String token, String kata) {
  final pola = RegExp('(?:$kata)\\b', caseSensitive: false);
  final cocok = pola.firstMatch(token);
  if (cocok == null) return null;
  final sisa = token.substring(cocok.end).trimLeft();
  if (sisa.isEmpty) return null;
  final bersih = bersihkanNamaOCR(sisa);
  if (bersih == null || bersih.toLowerCase().contains('rp')) return null;
  return _bukanKandidatMerchant(bawah: bersih) ? bersih : null;
}

String? _nilaiBarisBerikut(List<String> baris, int indeks) {
  final berikut = baris[indeks];
  if (_bukanKandidatMerchant(bawah: berikut)) return null;
  return bersihkanNamaOCR(berikut);
}

bool _bukanKandidatMerchant({required String bawah}) {
  final token = bawah.trim();
  if (token.isEmpty) return false;
  if (token.toLowerCase().contains('tanggal') ||
      token.toLowerCase().contains('waktu') ||
      token.toLowerCase().contains('jam')) {
    return false;
  }
  if (token.toLowerCase().contains('rp')) return false;
  final bersih = token.replaceAll(RegExp(r'[^0-9.,\s]'), '');
  if (bersih.trim().isEmpty) return true;
  if (RegExp(r'^\s*\d[\d.,]*\s*$').hasMatch(token)) return false;
  return true;
}
