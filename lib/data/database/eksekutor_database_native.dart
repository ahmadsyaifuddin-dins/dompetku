import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

QueryExecutor bukaEksekutorDatabase() {
  return LazyDatabase(() async {
    final direktori = await getApplicationDocumentsDirectory();
    final file = File(p.join(direktori.path, 'dompetku.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}