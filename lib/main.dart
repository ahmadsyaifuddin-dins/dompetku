import 'package:flutter/material.dart';

import 'utama/aplikasi.dart';
import 'utama/dependensi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Dependensi.inisialisasi();
  runApp(const AplikasiDompetKu());
}