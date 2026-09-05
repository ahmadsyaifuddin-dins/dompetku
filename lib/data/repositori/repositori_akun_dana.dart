import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import '../model/enum_dompetku.dart';

class RepositoriAkunDana {
  final DompetKuDatabase _database;
  const RepositoriAkunDana(this._database);

  Stream<List<AkunDanaData>> pantauSemuaAktif() {
    final query = _database.select(_database.akunDana)
      ..where((tabel) => tabel.aktif.equals(true))
      ..orderBy([
        (tabel) => OrderingTerm.asc(tabel.nama),
      ]);
    return query.watch();
  }

  Future<List<AkunDanaData>> ambilSemuaAktif() async {
    final query = _database.select(_database.akunDana)
      ..where((tabel) => tabel.aktif.equals(true))
      ..orderBy([
        (tabel) => OrderingTerm.asc(tabel.nama),
      ]);
    return query.get();
  }

  Stream<List<AkunDanaData>> pantauSemua() {
    final query = _database.select(_database.akunDana)
      ..orderBy([
        (tabel) => OrderingTerm.asc(tabel.nama),
      ]);
    return query.watch();
  }

  Future<AkunDanaData?> ambilBerdasarkanId(String id) async {
    final query = _database.select(_database.akunDana)
      ..where((tabel) => tabel.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<void> buat({
    required String nama,
    required JenisAkun jenis,
    int saldoAwal = 0,
    String? ikon,
  }) async {
    final sekarang = DateTime.now();
    await _database.into(_database.akunDana).insert(
          AkunDanaCompanion.insert(
            id: const Uuid().v4(),
            nama: nama,
            jenis: jenis,
            saldoAwal: Value(saldoAwal),
            ikon: Value(ikon),
            dibuatPada: sekarang,
            diperbaruiPada: sekarang,
          ),
        );
  }

  Future<void> perbaruiNama(String id, String nama) async {
    await (_database.update(_database.akunDana)
          ..where((tabel) => tabel.id.equals(id)))
        .write(
      AkunDanaCompanion(
        nama: Value(nama),
        diperbaruiPada: Value(DateTime.now()),
      ),
    );
  }

  Future<void> nonaktifkan(String id) async {
    await (_database.update(_database.akunDana)
          ..where((tabel) => tabel.id.equals(id)))
        .write(AkunDanaCompanion(aktif: const Value(false)));
  }
}