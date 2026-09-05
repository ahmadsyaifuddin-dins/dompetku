import 'package:dompetku/data/database/database.dart';
import 'package:dompetku/data/model/enum_dompetku.dart';
import 'package:dompetku/data/model/ringkasan_entri.dart';
import 'package:dompetku/inti/utilitas/gabung_entri_histori.dart';
import 'package:dompetku/inti/utilitas/hitung_saldo.dart';
import 'package:dompetku/inti/validasi/validasi_transaksi.dart';
import 'package:flutter_test/flutter_test.dart';

AkunDanaData _akun({
  required String id,
  required String nama,
  int saldoAwal = 0,
  bool aktif = true,
}) {
  return AkunDanaData(
    id: id,
    nama: nama,
    jenis: JenisAkun.bank,
    saldoAwal: saldoAwal,
    ikon: null,
    aktif: aktif,
    dibuatPada: DateTime(2026),
    diperbaruiPada: DateTime(2026),
  );
}

TransaksiData _transaksi({
  required String id,
  required String akunId,
  String? kategoriId,
  required JenisTransaksi jenis,
  required int nominal,
  DateTime? tanggal,
}) {
  return TransaksiData(
    id: id,
    akunDanaId: akunId,
    kategoriId: kategoriId,
    jenis: jenis,
    nominal: nominal,
    tanggal: tanggal ?? DateTime(2026),
    catatan: null,
    dibuatPada: DateTime(2026),
    diperbaruiPada: DateTime(2026),
  );
}

TransferData _transfer({
  required String id,
  required String asalId,
  required String tujuanId,
  required int nominal,
  DateTime? tanggal,
}) {
  return TransferData(
    id: id,
    akunAsalId: asalId,
    akunTujuanId: tujuanId,
    nominal: nominal,
    tanggal: tanggal ?? DateTime(2026),
    catatan: null,
    dibuatPada: DateTime(2026),
    diperbaruiPada: DateTime(2026),
  );
}

void main() {
  group('hitungSaldoAkun', () {
    test('mengikuti skenario integritas saldo pada PRD', () {
      final seaBank = _akun(id: 'seabank', nama: 'SeaBank', saldoAwal: 1000000);
      final tunai = _akun(id: 'cash', nama: 'Cash');

      final transaksi = [
        _transaksi(
          id: 't1',
          akunId: 'seabank',
          jenis: JenisTransaksi.pengeluaran,
          nominal: 100000,
        ),
      ];
      final transfer = [
        _transfer(id: 'x1', asalId: 'seabank', tujuanId: 'cash', nominal: 200000),
      ];

      final saldoSeaBank = hitungSaldoAkun(
        saldoAwal: seaBank.saldoAwal,
        idAkun: seaBank.id,
        transaksi: transaksi,
        transfer: transfer,
      );
      final saldoTunai = hitungSaldoAkun(
        saldoAwal: tunai.saldoAwal,
        idAkun: tunai.id,
        transaksi: transaksi,
        transfer: transfer,
      );

      expect(saldoSeaBank, 700000);
      expect(saldoTunai, 200000);

      final total = hitungTotalSaldo(
        [seaBank, tunai],
        transaksi,
        transfer,
      );
      expect(total, 900000);
    });

    test('pemasukan menambah saldo pengeluaran mengurangi saldo', () {
      final akun = _akun(id: 'a', nama: 'Akun', saldoAwal: 500000);
      final transaksi = [
        _transaksi(
          id: 'm1',
          akunId: 'a',
          jenis: JenisTransaksi.pemasukan,
          nominal: 200000,
        ),
        _transaksi(
          id: 'k1',
          akunId: 'a',
          jenis: JenisTransaksi.pengeluaran,
          nominal: 100000,
        ),
      ];

      final saldo = hitungSaldoAkun(
        saldoAwal: akun.saldoAwal,
        idAkun: akun.id,
        transaksi: transaksi,
      );

      expect(saldo, 600000);
    });

    test('mengabaikan transaksi dan transfer untuk akun lain', () {
      final akun = _akun(id: 'a', nama: 'Akun', saldoAwal: 100000);
      final transaksi = [
        _transaksi(
          id: 't',
          akunId: 'lain',
          jenis: JenisTransaksi.pengeluaran,
          nominal: 99999,
        ),
      ];
      final transfer = [
        _transfer(
          id: 'x',
          asalId: 'b',
          tujuanId: 'c',
          nominal: 50000,
        ),
      ];

      final saldo = hitungSaldoAkun(
        saldoAwal: akun.saldoAwal,
        idAkun: akun.id,
        transaksi: transaksi,
        transfer: transfer,
      );

      expect(saldo, 100000);
    });
  });

  group('hitungTotalSaldo', () {
    test('hanya menghitung akun yang aktif', () {
      final akunAktif = _akun(id: 'a', nama: 'Aktif', saldoAwal: 100000);
      final akunNonaktif = _akun(id: 'b', nama: 'Nonaktif', saldoAwal: 50000, aktif: false);

      final total = hitungTotalSaldo([akunAktif, akunNonaktif], [], []);

      expect(total, 100000);
    });
  });

  group('validasiTransfer', () {
    test('menolak nominal nol atau negatif', () {
      final asal = _akun(id: 'a', nama: 'A');
      final tujuan = _akun(id: 'b', nama: 'B');

      expect(
        validasiTransfer(akunAsal: asal, akunTujuan: tujuan, nominal: 0),
        isNotNull,
      );
      expect(
        validasiTransfer(akunAsal: asal, akunTujuan: tujuan, nominal: -1),
        isNotNull,
      );
    });

    test('menolak transfer ke akun yang sama', () {
      final asal = _akun(id: 'a', nama: 'A');

      expect(
        validasiTransfer(akunAsal: asal, akunTujuan: asal, nominal: 1000),
        isNotNull,
      );
    });

    test('transfer valid tidak menghasilkan galat', () {
      final asal = _akun(id: 'a', nama: 'A');
      final tujuan = _akun(id: 'b', nama: 'B');

      expect(
        validasiTransfer(akunAsal: asal, akunTujuan: tujuan, nominal: 1000),
        isNull,
      );
    });
  });

  group('gabungEntriHistori', () {
    test('menggabungkan dan mengurutkan transaksi serta transfer', () {
      final akunA = _akun(id: 'a', nama: 'SeaBank');
      final akunB = _akun(id: 'b', nama: 'Cash');
      final kategori = KategoriData(
        id: 'k1',
        nama: 'Makanan',
        jenis: JenisTransaksi.pengeluaran,
        ikon: null,
        aktif: true,
      );

      final transaksi = [
        _transaksi(
          id: 't1',
          akunId: 'a',
          kategoriId: 'k1',
          jenis: JenisTransaksi.pengeluaran,
          nominal: 75000,
          tanggal: DateTime(2026, 9, 5),
        ),
      ];
      final transfer = [
        _transfer(
          id: 'x1',
          asalId: 'a',
          tujuanId: 'b',
          nominal: 500000,
          tanggal: DateTime(2026, 9, 4),
        ),
      ];

      final entri = gabungEntriHistori(
        akun: {akunA.id: akunA, akunB.id: akunB},
        kategori: {kategori.id: kategori},
        transaksi: transaksi,
        transfer: transfer,
      );

      expect(entri, hasLength(2));
      expect(entri.first.id, 't1');
      expect(entri.first.label, 'Makanan');
      expect(entri.first.jenis, JenisEntri.pengeluaran);
      expect(entri[1].jenis, JenisEntri.transfer);
      expect(entri[1].namaAkun, 'SeaBank');
      expect(entri[1].namaAkunLawan, 'Cash');
    });
  });
}