import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';

class RepositoriTransfer {
  final DompetKuDatabase _database;
  const RepositoriTransfer(this._database);

  Stream<List<TransferData>> pantauSemua() {
    final query = _database.select(_database.transfer)
      ..orderBy([
        (tabel) => OrderingTerm.desc(tabel.tanggal),
      ]);
    return query.watch();
  }

  Future<void> tambah({
    required String akunAsalId,
    required String akunTujuanId,
    required int nominal,
    required DateTime tanggal,
    String? catatan,
  }) async {
    final sekarang = DateTime.now();
    await _database.into(_database.transfer).insert(
          TransferCompanion.insert(
            id: const Uuid().v4(),
            akunAsalId: akunAsalId,
            akunTujuanId: akunTujuanId,
            nominal: nominal,
            tanggal: tanggal,
            catatan: Value(catatan),
            dibuatPada: sekarang,
            diperbaruiPada: sekarang,
          ),
        );
  }

  Future<void> hapus(String id) async {
    await (_database.delete(_database.transfer)
          ..where((tabel) => tabel.id.equals(id)))
        .go();
  }
}