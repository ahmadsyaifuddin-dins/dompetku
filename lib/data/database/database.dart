import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../model/enum_dompetku.dart';
import 'eksekutor_database.dart';

part 'database.g.dart';

const int _versiDatabase = 1;

const String _defaultAkunNama = 'SeaBank';

class AkunDana extends Table {
  @override
  String get tableName => 'akun_dana';

  TextColumn get id => text()();
  TextColumn get nama => text()();
  TextColumn get jenis =>
      text().map(const EnumNameConverter<JenisAkun>(JenisAkun.values))();
  IntColumn get saldoAwal => integer().withDefault(const Constant(0))();
  TextColumn get ikon => text().nullable()();
  BoolColumn get aktif => boolean().withDefault(const Constant(true))();
  DateTimeColumn get dibuatPada => dateTime()();
  DateTimeColumn get diperbaruiPada => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Kategori extends Table {
  @override
  String get tableName => 'kategori';

  TextColumn get id => text()();
  TextColumn get nama => text()();
  TextColumn get jenis =>
      text().map(const EnumNameConverter<JenisTransaksi>(JenisTransaksi.values))();
  TextColumn get ikon => text().nullable()();
  BoolColumn get aktif => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class Transaksi extends Table {
  @override
  String get tableName => 'transaksi';

  TextColumn get id => text()();
  TextColumn get akunDanaId => text().named('akun_dana_id')();
  TextColumn get kategoriId => text().named('kategori_id').nullable()();
  TextColumn get jenis =>
      text().map(const EnumNameConverter<JenisTransaksi>(JenisTransaksi.values))();
  IntColumn get nominal => integer()();
  DateTimeColumn get tanggal => dateTime()();
  TextColumn get catatan => text().nullable()();
  DateTimeColumn get dibuatPada => dateTime().named('dibuat_pada')();
  DateTimeColumn get diperbaruiPada => dateTime().named('diperbarui_pada')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {akunDanaId},
        {kategoriId},
      ];
}

class Transfer extends Table {
  @override
  String get tableName => 'transfer';

  TextColumn get id => text()();
  TextColumn get akunAsalId => text().named('akun_asal_id')();
  TextColumn get akunTujuanId => text().named('akun_tujuan_id')();
  IntColumn get nominal => integer()();
  DateTimeColumn get tanggal => dateTime()();
  TextColumn get catatan => text().nullable()();
  DateTimeColumn get dibuatPada => dateTime().named('dibuat_pada')();
  DateTimeColumn get diperbaruiPada => dateTime().named('diperbarui_pada')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {akunAsalId},
        {akunTujuanId},
      ];
}

class Piutang extends Table {
  @override
  String get tableName => 'piutang';

  TextColumn get id => text()();
  TextColumn get nama => text()();
  TextColumn get catatan => text().nullable()();
  DateTimeColumn get dibuatPada => dateTime().named('dibuat_pada')();
  DateTimeColumn get diperbaruiPada => dateTime().named('diperbarui_pada')();

  @override
  Set<Column> get primaryKey => {id};
}

class RiwayatPiutang extends Table {
  @override
  String get tableName => 'riwayat_piutang';

  TextColumn get id => text()();
  TextColumn get piutangId => text().named('piutang_id')();
  TextColumn get jenis =>
      text().map(const EnumNameConverter<JenisRiwayat>(JenisRiwayat.values))();
  IntColumn get nominal => integer()();
  TextColumn get akunDanaId => text().named('akun_dana_id').nullable()();
  DateTimeColumn get tanggal => dateTime()();
  TextColumn get catatan => text().nullable()();
  DateTimeColumn get dibuatPada => dateTime().named('dibuat_pada')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {piutangId},
        {akunDanaId},
      ];
}

@DriftDatabase(
  tables: [
    AkunDana,
    Kategori,
    Transaksi,
    Transfer,
    Piutang,
    RiwayatPiutang,
  ],
)
class DompetKuDatabase extends _$DompetKuDatabase {
  DompetKuDatabase([QueryExecutor? eksekutor])
      : super(eksekutor ?? bukaEksekutorDatabase());

  @override
  int get schemaVersion => _versiDatabase;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _buatDataAwal();
        },
        onUpgrade: (m, dari, ke) async {
          // Migrasi ber-version akan ditambahkan di sini di versi berikutnya.
        },
        beforeOpen: (detail) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _buatDataAwal() async {
    await into(akunDana).insert(
      AkunDanaCompanion.insert(
        id: const Uuid().v4(),
        nama: _defaultAkunNama,
        jenis: JenisAkun.bank,
        dibuatPada: DateTime.now(),
        diperbaruiPada: DateTime.now(),
      ),
    );
  }
}