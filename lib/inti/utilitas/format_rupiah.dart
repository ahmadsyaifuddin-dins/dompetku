import 'package:intl/intl.dart';

final NumberFormat _formatRupiah = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 0,
);

String formatRupiah(int nominal) => _formatRupiah.format(nominal);