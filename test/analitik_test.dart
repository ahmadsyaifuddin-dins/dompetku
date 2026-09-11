import 'package:dompetku/data/database/database.dart';
import 'package:dompetku/data/model/enum_dompetku.dart';
import 'package:dompetku/core/utils/hitung_analitik.dart';
import 'package:flutter_test/flutter_test.dart';

TransaksiData _transaksi(
  String id, {
  required JenisTransaksi jenis,
  required int nominal,
  required DateTime tanggal,
  String? kategoriId,
}) {
  return TransaksiData(
    id: id,
    akunDanaId: 'a',
    kategoriId: kategoriId,
    jenis: jenis,
    nominal: nominal,
    tanggal: tanggal,
    catatan: null,
    dibuatPada: tanggal,
    diperbaruiPada: tanggal,
  );
}

KategoriData _kategori(String id, String nama) {
  return KategoriData(
    id: id,
    nama: nama,
    jenis: JenisTransaksi.pengeluaran,
    ikon: null,
    aktif: true,
  );
}

void main() {
  group('ringkasArusPeriode', () {
    test('menjumlahkan pemasukan dan pengeluaran dalam rentang tanggal',
        () {
      final transaksi = [
        _transaksi('1',
            jenis: JenisTransaksi.pemasukan,
            nominal: 500000,
            tanggal: DateTime(2026, 3, 5)),
        _transaksi('2',
            jenis: JenisTransaksi.pengeluaran,
            nominal: 100000,
            tanggal: DateTime(2026, 3, 10)),
        _transaksi('3',
            jenis: JenisTransaksi.pengeluaran,
            nominal: 200000,
            tanggal: DateTime(2026, 3, 10)),
        _transaksi('4',
            jenis: JenisTransaksi.pemasukan,
            nominal: 999999,
            tanggal: DateTime(2026, 3, 1)),
      ];

      final arus = ringkasArusPeriode(
        transaksi: transaksi,
        awal: DateTime(2026, 3, 5),
        akhir: DateTime(2026, 3, 10),
      );

      expect(arus.totalPemasukan, 500000);
      expect(arus.totalPengeluaran, 300000);
      expect(arus.selisih, 200000);
    });

    test('rentang kosong menghasilkan nol', () {
      final arus = ringkasArusPeriode(
        transaksi: const [],
        awal: DateTime(2026, 1, 1),
        akhir: DateTime(2026, 1, 31),
      );

      expect(arus.totalPemasukan, 0);
      expect(arus.totalPengeluaran, 0);
    });
  });

  group('ringkasArusBulan', () {
    test('mencakup seluruh hari dalam bulan', () {
      final transaksi = [
        _transaksi('1',
            jenis: JenisTransaksi.pemasukan,
            nominal: 100000,
            tanggal: DateTime(2026, 2, 1)),
        _transaksi('2',
            jenis: JenisTransaksi.pengeluaran,
            nominal: 25000,
            tanggal: DateTime(2026, 2, 28)),
        _transaksi('3',
            jenis: JenisTransaksi.pemasukan,
            nominal: 100000,
            tanggal: DateTime(2026, 3, 1)),
      ];

      final arus = ringkasArusBulan(
        transaksi: transaksi,
        bulan: DateTime(2026, 2),
      );

      expect(arus.totalPemasukan, 100000);
      expect(arus.totalPengeluaran, 25000);
    });
  });

  group('dataArusBulanan', () {
    test('menghasilkan urutan bulan dan label singkat', () {
      final transaksi = [
        _transaksi('1',
            jenis: JenisTransaksi.pemasukan,
            nominal: 100000,
            tanggal: DateTime(2026, 3, 5)),
      ];

      final data = dataArusBulanan(
        transaksi: transaksi,
        sampai: DateTime(2026, 3),
        jumlahBulan: 6,
      );

      expect(data.length, 6);
      expect(data.first.label, 'Okt');
      expect(data.first.pemasukan, 0);
      expect(data.last.label, 'Mar');
      expect(data.last.pemasukan, 100000);
      expect(data[4].bulan, DateTime(2026, 2, 1));
    });
  });

  group('hitungDistribusiPengeluaran', () {
    test('mengelompokkan pengeluaran per kategori dan memberi persen',
        () {
      final petaKategori = {
        'makan': _kategori('makan', 'Makanan'),
        'transport': _kategori('transport', 'Transportasi'),
      };
      final transaksi = [
        _transaksi('1',
            jenis: JenisTransaksi.pengeluaran,
            nominal: 60000,
            tanggal: DateTime(2026, 1, 2),
            kategoriId: 'makan'),
        _transaksi('2',
            jenis: JenisTransaksi.pengeluaran,
            nominal: 40000,
            tanggal: DateTime(2026, 1, 3),
            kategoriId: 'transport'),
        _transaksi('3',
            jenis: JenisTransaksi.pemasukan,
            nominal: 999999,
            tanggal: DateTime(2026, 1, 4),
            kategoriId: 'makan'),
      ];

      final distribusi = hitungDistribusiPengeluaran(
        transaksi: transaksi,
        petaKategori: petaKategori,
        awal: DateTime(2026, 1, 1),
        akhir: DateTime(2026, 1, 31),
      );

      expect(distribusi.length, 2);
      expect(distribusi.first.nama, 'Makanan');
      expect(distribusi.first.total, 60000);
      expect(distribusi.first.persen, 60);
      expect(distribusi[1].persen, 40);
    });

    test('tanpa pengeluaran menghasilkan daftar kosong', () {
      final distribusi = hitungDistribusiPengeluaran(
        transaksi: const [],
        petaKategori: {},
        awal: DateTime(2026, 1, 1),
        akhir: DateTime(2026, 1, 31),
      );

      expect(distribusi, isEmpty);
    });
  });

  test('namaBulanSingkat memetakan bulan dengan benar', () {
    expect(namaBulanSingkat(1), 'Jan');
    expect(namaBulanSingkat(6), 'Jun');
    expect(namaBulanSingkat(12), 'Des');
  });
}