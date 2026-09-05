import 'package:intl/intl.dart';

final NumberFormat _formatRupiah = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 0,
);

final NumberFormat _formatAngka = NumberFormat.decimalPattern('id_ID');

String formatRupiah(int nominal) => _formatRupiah.format(nominal);

String formatNominalInput(String teks) {
  final angka = teks.replaceAll(RegExp(r'[^0-9]'), '');
  if (angka.isEmpty) return '';
  final nilai = int.tryParse(angka) ?? 0;
  return _formatAngka.format(nilai);
}

int? parseNominalInput(String teks) {
  final angka = teks.replaceAll(RegExp(r'[^0-9]'), '');
  if (angka.isEmpty) return null;
  return int.tryParse(angka);
}