import 'package:flutter/foundation.dart';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

QueryExecutor bukaEksekutorDatabase() {
  return DatabaseConnection.delayed(Future(() async {
    final hasil = await WasmDatabase.open(
      databaseName: 'dompetku',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (hasil.missingFeatures.isNotEmpty) {
      // Info pengembangan: impl store dipilih otomatis oleh drift.
      debugPrint('drift web: ${hasil.chosenImplementation} '
          'karena fitur browser tidak lengkap: ${hasil.missingFeatures}');
    }

    return hasil.resolvedExecutor;
  }));
}