import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/database.dart';
import '../model/enum_dompetku.dart';

class RepositoriPiutang {
  final DompetKuDatabase _database;
  const RepositoriPiutang(this._database);

  Stream<List<PiutangData>> pantauSemua() {
    final query = _database.select(_database.piutang)
      ..orderBy([
        (tabel) => OrderingTerm.asc(tabel.nama),
      ]);
    return query.watch();
  }

  Future<PiutangData?> ambilBerdasarkanId(String id) async {
    final query = _database.select(_database.piutang)
      ..where((tabel) => tabel.id.equals(id));
    return query.getSingleOrNull();
  }

  Stream<List<RiwayatPiutangData>> pantauSemuaRiwayat() {
    final query = _database.select(_database.riwayatPiutang)
      ..orderBy([
        (tabel) => OrderingTerm.desc(tabel.tanggal),
      ]);
    return query.watch();
  }

  Stream<List<RiwayatPiutangData>> pantauRiwayat(String piutangId) {
    final query = _database.select(_database.riwayatPiutang)
      ..where((tabel) => tabel.piutangId.equals(piutangId))
      ..orderBy([
        (tabel) => OrderingTerm.desc(tabel.tanggal),
      ]);
    return query.watch();
  }

  Future<String> buatPiutang({
    required String nama,
    String? catatan,
  }) async {
    final id = const Uuid().v4();
    final sekarang = DateTime.now();
    await _database.into(_database.piutang).insert(
          PiutangCompanion.insert(
            id: id,
            nama: nama,
            catatan: Value(catatan),
            dibuatPada: sekarang,
            diperbaruiPada: sekarang,
          ),
        );
    return id;
  }

  Future<void> perbaruiPiutang({
    required String id,
    required String nama,
    String? catatan,
  }) async {
    await (_database.update(_database.piutang)
          ..where((tabel) => tabel.id.equals(id)))
        .write(
          PiutangCompanion(
            nama: Value(nama),
            catatan: Value(catatan),
            diperbaruiPada: Value(DateTime.now()),
          ),
        );
  }

  Future<void> catatPinjaman({
    required String piutangId,
    required String akunDanaId,
    required int nominal,
    required DateTime tanggal,
    String? catatan,
  }) async {
    await catatRiwayat(
      piutangId: piutangId,
      jenis: JenisRiwayat.pinjaman,
      nominal: nominal,
      akunDanaId: akunDanaId,
      tanggal: tanggal,
      catatan: catatan,
    );
  }

  Future<void> catatTambahan({
    required String piutangId,
    required String akunDanaId,
    required int nominal,
    required DateTime tanggal,
    String? catatan,
  }) async {
    await catatRiwayat(
      piutangId: piutangId,
      jenis: JenisRiwayat.tambahan,
      nominal: nominal,
      akunDanaId: akunDanaId,
      tanggal: tanggal,
      catatan: catatan,
    );
  }

  Future<void> catatPembayaran({
    required String piutangId,
    required String akunDanaId,
    required int nominal,
    required DateTime tanggal,
    String? catatan,
  }) async {
    await catatRiwayat(
      piutangId: piutangId,
      jenis: JenisRiwayat.pembayaran,
      nominal: nominal,
      akunDanaId: akunDanaId,
      tanggal: tanggal,
      catatan: catatan,
    );
  }

  Future<void> catatRiwayat({
    required String piutangId,
    required JenisRiwayat jenis,
    required int nominal,
    required String akunDanaId,
    required DateTime tanggal,
    String? catatan,
  }) async {
    await _database.into(_database.riwayatPiutang).insert(
          RiwayatPiutangCompanion.insert(
            id: const Uuid().v4(),
            piutangId: piutangId,
            jenis: jenis,
            nominal: nominal,
            akunDanaId: Value(akunDanaId),
            tanggal: tanggal,
            catatan: Value(catatan),
            dibuatPada: DateTime.now(),
          ),
        );
    await _perbaruiStempelPiutang(piutangId);
  }

  Future<void> hapusPiutang(String id) async {
    await (_database.delete(_database.riwayatPiutang)
          ..where((tabel) => tabel.piutangId.equals(id)))
        .go();
    await (_database.delete(_database.piutang)
          ..where((tabel) => tabel.id.equals(id)))
        .go();
  }

  Future<void> _perbaruiStempelPiutang(String id) async {
    await (_database.update(_database.piutang)
          ..where((tabel) => tabel.id.equals(id)))
        .write(PiutangCompanion(diperbaruiPada: Value(DateTime.now())));
  }
}