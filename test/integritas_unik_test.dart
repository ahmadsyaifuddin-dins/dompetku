import 'dart:io';

import 'package:dompetku/data/database/database.dart';
import 'package:dompetku/data/model/enum_dompetku.dart';
import 'package:dompetku/data/repositori/repositori_piutang.dart';
import 'package:dompetku/data/repositori/repositori_transaksi.dart';
import 'package:dompetku/data/repositori/repositori_transfer.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DompetKuDatabase database;
  late RepositoriTransaksi repositoriTransaksi;
  late RepositoriTransfer repositoriTransfer;
  late RepositoriPiutang repositoriPiutang;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    database = DompetKuDatabase(NativeDatabase.memory());
    repositoriTransaksi = RepositoriTransaksi(database);
    repositoriTransfer = RepositoriTransfer(database);
    repositoriPiutang = RepositoriPiutang(database);
  });

  tearDown(() async {
    await database.close();
  });

  Future<String> buatAkun(String nama) async {
    final id = 'akun-$nama';
    await database.into(database.akunDana).insert(
          AkunDanaCompanion.insert(
            id: id,
            nama: nama,
            jenis: JenisAkun.bank,
            saldoAwal: const Value(0),
            dibuatPada: DateTime(2026),
            diperbaruiPada: DateTime(2026),
          ),
        );
    return id;
  }

  Future<String> buatKategori(String nama) async {
    final id = 'kategori-$nama';
    await database.into(database.kategori).insert(
          KategoriCompanion.insert(
            id: id,
            nama: nama,
            jenis: JenisTransaksi.pemasukan,
          ),
        );
    return id;
  }

  Future<String> buatPiutang(String nama) async {
    final id = 'piutang-$nama';
    await database.into(database.piutang).insert(
          PiutangCompanion.insert(
            id: id,
            nama: nama,
            dibuatPada: DateTime(2026),
            diperbaruiPada: DateTime(2026),
          ),
        );
    return id;
  }

  group('registri database bukan unik per baris', () {
    test('dua transaksi pada akun yang sama tersimpan', () async {
      final idAkun = await buatAkun('SeaBank');
      final idKategori = await buatKategori('Gaji');

      await repositoriTransaksi.tambah(
        akunDanaId: idAkun,
        kategoriId: idKategori,
        jenis: JenisTransaksi.pemasukan,
        nominal: 100000,
        tanggal: DateTime(2026, 1, 1),
      );
      await repositoriTransaksi.tambah(
        akunDanaId: idAkun,
        kategoriId: idKategori,
        jenis: JenisTransaksi.pemasukan,
        nominal: 50000,
        tanggal: DateTime(2026, 1, 2),
      );

      final jumlah = (await database.select(database.transaksi).get()).length;
      expect(jumlah, 2);
    });

    test('dua transfer dari akun yang sama tersimpan', () async {
      final asal = await buatAkun('SeaBank');
      final tujuan = await buatAkun('GoPay');

      await repositoriTransfer.tambah(
        akunAsalId: asal,
        akunTujuanId: tujuan,
        nominal: 10000,
        tanggal: DateTime(2026, 1, 1),
      );
      await repositoriTransfer.tambah(
        akunAsalId: asal,
        akunTujuanId: tujuan,
        nominal: 20000,
        tanggal: DateTime(2026, 1, 2),
      );

      final jumlah = (await database.select(database.transfer).get()).length;
      expect(jumlah, 2);
    });

    test('pinjaman lalu pembayaran untuk piutang yang sama tersimpan', () async {
      final idAkun = await buatAkun('SeaBank');
      final idPiutang = await buatPiutang('Budi');

      await repositoriPiutang.catatPinjaman(
        piutangId: idPiutang,
        akunDanaId: idAkun,
        nominal: 500000,
        tanggal: DateTime(2026, 1, 1),
      );
      await repositoriPiutang.catatPembayaran(
        piutangId: idPiutang,
        akunDanaId: idAkun,
        nominal: 100000,
        tanggal: DateTime(2026, 1, 2),
      );

      final jumlah =
          (await database.select(database.riwayatPiutang).get()).length;
      expect(jumlah, 2);
    });
  });

  group('migrasi dari skema v1', () {
    test('menghapus constraint unik namun tetap menyimpan data lama', () async {
      final direktori = await Directory.systemTemp.createTemp('dompetku_');
      final berkas = File('${direktori.path}/dompetku_migrasi.db');

      final dbAwal = DompetKuDatabase(NativeDatabase(berkas));
      await dbAwal.transaction(() async {
        await dbAwal.customStatement('DROP TABLE "transaksi"');
        await dbAwal.customStatement('DROP TABLE "transfer"');
        await dbAwal.customStatement('DROP TABLE "riwayat_piutang"');
        await dbAwal.customStatement(
          'CREATE TABLE "transaksi" ('
          '"id" TEXT NOT NULL, "akun_dana_id" TEXT NOT NULL, '
          '"kategori_id" TEXT, "jenis" TEXT NOT NULL, "nominal" INTEGER NOT NULL, '
          '"tanggal" INTEGER NOT NULL, "catatan" TEXT, '
          '"dibuat_pada" INTEGER NOT NULL, "diperbarui_pada" INTEGER NOT NULL, '
          'PRIMARY KEY ("id"), UNIQUE ("akun_dana_id"), UNIQUE ("kategori_id"))',
        );
        await dbAwal.customStatement(
          'CREATE TABLE "transfer" ('
          '"id" TEXT NOT NULL, "akun_asal_id" TEXT NOT NULL, '
          '"akun_tujuan_id" TEXT NOT NULL, "nominal" INTEGER NOT NULL, '
          '"tanggal" INTEGER NOT NULL, "catatan" TEXT, '
          '"dibuat_pada" INTEGER NOT NULL, "diperbarui_pada" INTEGER NOT NULL, '
          'PRIMARY KEY ("id"), UNIQUE ("akun_asal_id"), UNIQUE ("akun_tujuan_id"))',
        );
        await dbAwal.customStatement(
          'CREATE TABLE "riwayat_piutang" ('
          '"id" TEXT NOT NULL, "piutang_id" TEXT NOT NULL, '
          '"jenis" TEXT NOT NULL, "nominal" INTEGER NOT NULL, '
          '"akun_dana_id" TEXT, "tanggal" INTEGER NOT NULL, "catatan" TEXT, '
          '"dibuat_pada" INTEGER NOT NULL, '
          'PRIMARY KEY ("id"), UNIQUE ("piutang_id"), UNIQUE ("akun_dana_id"))',
        );
        await dbAwal.customStatement(
          "INSERT INTO \"transaksi\" VALUES "
          "('t1','akun-1',NULL,'pemasukan',100000,1767283200,NULL,"
          '1790242110,1790242110)',
        );
        await dbAwal.customStatement(
          "INSERT INTO \"transfer\" VALUES "
          "('tf1','akun-1','akun-2',25000,1767283200,NULL,"
          '1790242110,1790242110)',
        );
        await dbAwal.customStatement(
          "INSERT INTO \"riwayat_piutang\" VALUES "
          "('r1','p1','pinjaman',500000,'akun-1',1767283200,NULL,1790242110)",
        );
        await dbAwal.customStatement('PRAGMA user_version = 1');
      });
      await dbAwal.close();

      final dbBaru = DompetKuDatabase(NativeDatabase(berkas));
      final versiBaru = (await dbBaru.customSelect('PRAGMA user_version')
              .getSingle())
          .read<int>('user_version');
      expect(versiBaru, 2);

      final transaksiLama =
          (await dbBaru.select(dbBaru.transaksi).get()).length;
      final transferLama = (await dbBaru.select(dbBaru.transfer).get()).length;
      final riwayatLama = (await dbBaru.select(dbBaru.riwayatPiutang).get());
      expect(transaksiLama, 1);
      expect(transferLama, 1);
      expect(riwayatLama.single.nominal, 500000);

      await RepositoriTransaksi(dbBaru).tambah(
        akunDanaId: 'akun-1',
        kategoriId: null,
        jenis: JenisTransaksi.pemasukan,
        nominal: 70000,
        tanggal: DateTime(2026, 1, 3),
      );
      final jumlahKini =
          (await dbBaru.select(dbBaru.transaksi).get()).length;
      expect(jumlahKini, 2);

      await dbBaru.close();
      direktori.delete(recursive: true);
    });
  });
}