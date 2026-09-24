/// Membersihkan tanda baca/spasi di awal dan akhir nama.
/// Mengembalikan null bila hasilnya kosong.
String? bersihkanNamaOCR(String nilai) {
  final bersih = nilai.replaceAll(RegExp(r'^[:,.|\s]+|[:,.|\s]+$'), '').trim();
  if (bersih.isEmpty) return null;
  return bersih;
}
