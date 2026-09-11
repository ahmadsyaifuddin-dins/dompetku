import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import '../model/enum_dompetku.dart';

class RepositoriKategori {
  final DompetKuDatabase _database;
  const RepositoriKategori(this._database);

  Stream<List<KategoriData>> pantauSemua() {
    final query = _database.select(_database.kategori)
      ..orderBy([
        (tabel) => OrderingTerm.asc(tabel.nama),
      ]);
    return query.watch();
  }

  Stream<List<KategoriData>> pantauAktif({JenisTransaksi? jenis}) {
    return _regexAktif(jenis).watch();
  }

  Future<List<KategoriData>> ambilAktif({JenisTransaksi? jenis}) async {
    return _regexAktif(jenis).get();
  }

  SimpleSelectStatement<HasResultSet, KategoriData> _regexAktif(
    JenisTransaksi? jenis,
  ) {
    final query = _database.select(_database.kategori)
      ..where((tabel) {
        final kondisi = tabel.aktif.equals(true);
        if (jenis != null) {
          return kondisi & tabel.jenis.equalsValue(jenis);
        }
        return kondisi;
      })
      ..orderBy([
        (tabel) => OrderingTerm.asc(tabel.nama),
      ]);
    return query;
  }

  Future<void> buat({
    required String nama,
    required JenisTransaksi jenis,
    String? ikon,
  }) async {
    await _database.into(_database.kategori).insert(
          KategoriCompanion.insert(
            id: const Uuid().v4(),
            nama: nama,
            jenis: jenis,
            ikon: Value(ikon),
          ),
        );
  }

  Future<void> nonaktifkan(String id) async {
    await (_database.update(_database.kategori)
          ..where((tabel) => tabel.id.equals(id)))
        .write(const KategoriCompanion(aktif: Value(false)));
  }

  Future<void> perbarui({
    required String id,
    required String nama,
    String? ikon,
  }) async {
    await (_database.update(_database.kategori)
          ..where((tabel) => tabel.id.equals(id)))
        .write(
          KategoriCompanion(
            nama: Value(nama),
            ikon: Value(ikon),
          ),
        );
  }
}