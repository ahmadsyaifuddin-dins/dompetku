import 'package:dompetku/data/model/ringkasan_entri.dart';
import 'package:dompetku/fitur/transaksi/histori_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pemasukan = EntriHistori(
    id: 't-1',
    jenis: JenisEntri.pemasukan,
    nominal: 50000,
    tanggal: DateTime(2026, 3, 5, 10),
    label: 'Gaji',
    namaAkun: 'SeaBank',
    akunDanaId: 'akun-1',
    kategoriId: 'k-makan',
  );

  final pengeluaran = EntriHistori(
    id: 't-2',
    jenis: JenisEntri.pengeluaran,
    nominal: 15000,
    tanggal: DateTime(2026, 3, 10, 12),
    label: 'Makan Siang',
    namaAkun: 'Cash',
    akunDanaId: 'akun-2',
    kategoriId: 'k-makan',
  );

  final transfer = EntriHistori(
    id: 'tf-1',
    jenis: JenisEntri.transfer,
    nominal: 20000,
    tanggal: DateTime(2026, 2, 28, 8),
    label: 'Transfer',
    namaAkun: 'SeaBank',
    namaAkunLawan: 'Cash',
    akunDanaId: 'akun-1',
  );

  final histori = [pemasukan, pengeluaran, transfer];

  test('saringHistori tanpa kriteria mengembalikan semua', () {
    expect(saringHistori(histori), histori);
  });

  test('saringHistori memfilter jenis entri', () {
    final hasil = saringHistori(histori, jenis: JenisEntri.pengeluaran);
    expect(hasil, [pengeluaran]);
  });

  test('saringHistori memfilter kategori', () {
    final hasil = saringHistori(histori, kategoriId: 'k-makan');
    expect(hasil, [pemasukan, pengeluaran]);
  });

  test('saringHistori memfilter akun dana', () {
    final hasil = saringHistori(histori, akunDanaId: 'akun-1');
    expect(hasil, [pemasukan, transfer]);
  });

  test('saringHistori memfilter rentang tanggal mencakup seluruh hari akhir',
      () {
    final hasil = saringHistori(
      histori,
      tanggalAwal: DateTime(2026, 3, 1),
      tanggalAkhir: DateTime(2026, 3, 10),
    );
    expect(hasil, [pemasukan, pengeluaran]);
  });

  test('saringHistori menggabungkan beberapa kriteria sekaligus', () {
    final hasil = saringHistori(
      histori,
      jenis: JenisEntri.pemasukan,
      tanggalAwal: DateTime(2026, 3, 1),
    );
    expect(hasil, [pemasukan]);
  });
}