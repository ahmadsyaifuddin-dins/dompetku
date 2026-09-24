const _kataTanggal = ['tanggal', 'tgl', 'date', 'waktu'];

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

const _namaBulanSingkat = {
  'jan': 1,
  'feb': 2,
  'mar': 3,
  'apr': 4,
  'mei': 5,
  'jun': 6,
  'jul': 7,
  'agu': 8,
  'aug': 8,
  'sep': 9,
  'okt': 10,
  'nov': 11,
  'des': 12,
};

DateTime? cariTanggalDariTeks(List<String> baris) {
  DateTime? hasil;
  for (final token in baris) {
    final pisah = token.indexOf(':');
    if (pisah >= 0) {
      final kunci = token.substring(0, pisah).trim().toLowerCase();
      final nilai = token.substring(pisah + 1).trim();
      for (final kata in _kataTanggal) {
        if (kunci == kata || kunci.contains(kata)) {
          final t = parseTanggalOCR(nilai.isEmpty ? token : nilai);
          if (t != null) return t;
        }
      }
    }
    hasil ??= parseTanggalOCR(token);
  }
  return hasil;
}

DateTime? parseTanggalOCR(String nilai) {
  final iso = DateTime.tryParse(nilai);
  if (iso != null) return iso;

  final bagian = nilai
      .split(RegExp(r'[/\\\-\. ]+'))
      .where((b) => b.isNotEmpty)
      .toList();
  if (bagian.length < 3) return null;
  return _tanggalDariBagian(bagian.sublist(0, 3));
}

DateTime? _tanggalDariBagian(List<String> b) {
  if (b.length < 3) return null;
  final tanggal = int.tryParse(b[0]);
  final tahun = int.tryParse(b[2]);
  if (tahun == null || tanggal == null) return null;

  // Cek apakah bagian bulan berupa angka
  final bulanAngka = int.tryParse(b[1]);
  if (bulanAngka != null && bulanAngka >= 1 && bulanAngka <= 12) {
    return DateTime(tahun, bulanAngka, tanggal);
  }

  // Cek apakah bulan berupa teks (panjang atau singkat)
  final teksBulan = b[1].toLowerCase();

  // Cek dari map singkat
  if (_namaBulanSingkat.containsKey(teksBulan)) {
    return DateTime(tahun, _namaBulanSingkat[teksBulan]!, tanggal);
  }

  // Cek dari list panjang _namaBulan
  final indeksBulan = _namaBulan.indexOf(teksBulan);
  if (indeksBulan >= 0) {
    return DateTime(tahun, indeksBulan + 1, tanggal);
  }

  return null;
}
