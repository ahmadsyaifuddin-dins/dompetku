import 'util_teks_ocr.dart';

const _kataMetode = [
  'gopay',
  'ovo',
  'dana',
  'shopeepay',
  'linkaja',
  'seabank',
  'sea bank',
  'bca',
  'bni',
  'bri',
  'mandiri',
  'permata',
  'jenius',
  'bsi',
  'maybank',
  'digibank',
  'bank saqu',
];

String? cariMetodeDariTeks(List<String> baris) {
  for (final token in baris) {
    for (final nama in _kataMetode) {
      final pola = RegExp('(?:$nama)\\b', caseSensitive: false);
      final cocok = pola.firstMatch(token);
      if (cocok != null) {
        final nilai = bersihkanNamaOCR(cocok.group(0)!);
        if (nilai != null) return nilai;
      }
    }
  }
  return null;
}
