import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'utama/aplikasi.dart';
import 'utama/dependensi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Dependensi.inisialisasi();
  runApp(const AplikasiDompetKu());
}