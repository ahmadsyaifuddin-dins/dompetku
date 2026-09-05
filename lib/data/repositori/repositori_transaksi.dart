import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import '../model/enum_dompetku.dart';
import '../model/ringkasan_entri.dart';

class RepositoriTransaksi {
  final DompetKuDatabase _database;
  const RepositoriTransaksi(this._database);

  Stream<List<TransaksiData>> pantauSemua() {
    final query = _database.select(_database.transaksi)
      ..orderBy([
        (tabel) => OrderingTerm.desc(tabel.tanggal),
      ]);
    return query.watch();
  }

  Stream<List<RingkasanTransaksi>> pantauRingkasan() {
    final query = _database
        .select(_database.transaksi)
        .join([
          innerJoin(
            _database.akunDana,
            _database.akunDana.id.equalsExp(_database.transaksi.akunDanaId),
          ),
          leftOuterJoin(
            _database.kategori,
            _database.kategori.id.equalsExp(_database.transaksi.kategoriId),
          ),
        ])
      ..orderBy([OrderingTerm.desc(_database.transaksi.tanggal)]);

    return query.watch().map(
          (baris) => baris
              .map(
                (r) => RingkasanTransaksi(
                  transaksi: r.readTable(_database.transaksi),
                  akun: r.readTable(_database.akunDana),
                  kategori: r.readTableOrNull(_database.kategori),
                ),
              )
              .toList(),
        );
  }

  Future<void> tambah({
    required String akunDanaId,
    String? kategoriId,
    required JenisTransaksi jenis,
    required int nominal,
    required DateTime tanggal,
    String? catatan,
  }) async {
    final sekarang = DateTime.now();
    await _database.into(_database.transaksi).insert(
          TransaksiCompanion.insert(
            id: const Uuid().v4(),
            akunDanaId: akunDanaId,
            kategoriId: Value(kategoriId),
            jenis: jenis,
            nominal: nominal,
            tanggal: tanggal,
            catatan: Value(catatan),
            dibuatPada: sekarang,
            diperbaruiPada: sekarang,
          ),
        );
  }

  Future<void> hapus(String id) async {
    await (_database.delete(_database.transaksi)
          ..where((tabel) => tabel.id.equals(id)))
        .go();
  }
}