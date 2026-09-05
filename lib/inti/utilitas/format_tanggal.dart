import 'package:intl/intl.dart';

final DateFormat _formatTanggal = DateFormat('d MMMM y', 'id_ID');

String formatTanggal(DateTime tanggal) => _formatTanggal.format(tanggal);