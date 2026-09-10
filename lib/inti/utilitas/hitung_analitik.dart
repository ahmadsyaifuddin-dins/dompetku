import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';

class RingkasanArus {
  final DateTime awal;
  final DateTime akhir;
  final int totalPemasukan;
  final int totalPengeluaran;

  const RingkasanArus({
    required this.awal,
    required this.akhir,
    required this.totalPemasukan,
    required this.totalPengeluaran,
  });

  int get selisih => totalPemasukan - totalPengeluaran;
}

/// Merangkum total pemasukan dan pengeluaran dalam rentang tanggal
/// [awal] (inklusif) sampai [akhir] (inklusif).
RingkasanArus ringkasArusPeriode({
  required List<TransaksiData> transaksi,
  required DateTime awal,
  required DateTime akhir,
}) {
  var totalPemasukan = 0;
  var totalPengeluaran = 0;
  for (final t in transaksi) {
    final tanggal = DateTime(t.tanggal.year, t.tanggal.month, t.tanggal.day);
    if (tanggal.isBefore(awal) || tanggal.isAfter(akhir)) continue;
    switch (t.jenis) {
      case JenisTransaksi.pemasukan:
        totalPemasukan += t.nominal;
      case JenisTransaksi.pengeluaran:
        totalPengeluaran += t.nominal;
    }
  }
  return RingkasanArus(
    awal: awal,
    akhir: akhir,
    totalPemasukan: totalPemasukan,
    totalPengeluaran: totalPengeluaran,
  );
}

/// Merangkum cakupan satu bulan kalender (dari hari pertama sampai
/// hari terakhir bulan).
RingkasanArus ringkasArusBulan({
  required List<TransaksiData> transaksi,
  required DateTime bulan,
}) {
  final pertama = DateTime(bulan.year, bulan.month, 1);
  final terakhir = DateTime(bulan.year, bulan.month + 1, 0);
  return ringkasArusPeriode(
    transaksi: transaksi,
    awal: pertama,
    akhir: terakhir,
  );
}

class DataArusBulanan {
  final DateTime bulan;
  final String label;
  final int pemasukan;
  final int pengeluaran;

  const DataArusBulanan({
    required this.bulan,
    required this.label,
    required this.pemasukan,
    required this.pengeluaran,
  });
}

/// Mengambil [jumlahBulan] bulan berjalan sampai [sampai] (inklusif),
/// diurutkan dari yang paling lama.
List<DataArusBulanan> dataArusBulanan({
  required List<TransaksiData> transaksi,
  required DateTime sampai,
  int jumlahBulan = 6,
}) {
  final hasil = <DataArusBulanan>[];
  final bulanAwal = DateTime(sampai.year, sampai.month - (jumlahBulan - 1), 1);
  for (var i = 0; i < jumlahBulan; i++) {
    final bulan = DateTime(bulanAwal.year, bulanAwal.month + i, 1);
    final arus = ringkasArusBulan(transaksi: transaksi, bulan: bulan);
    hasil.add(
      DataArusBulanan(
        bulan: bulan,
        label: namaBulanSingkat(bulan.month),
        pemasukan: arus.totalPemasukan,
        pengeluaran: arus.totalPengeluaran,
      ),
    );
  }
  return hasil;
}

class DistribusiKategori {
  final String kategoriId;
  final String nama;
  final int total;
  final double persen;

  const DistribusiKategori({
    required this.kategoriId,
    required this.nama,
    required this.total,
    required this.persen,
  });
}

/// Menghitung distribusi pengeluaran per kategori pada periode [awal]
/// sampai [akhir], diurutkan dari yang terbesar.
List<DistribusiKategori> hitungDistribusiPengeluaran({
  required List<TransaksiData> transaksi,
  required Map<String, KategoriData> petaKategori,
  required DateTime awal,
  required DateTime akhir,
}) {
  final perKategori = <String, int>{};
  for (final t in transaksi) {
    if (t.jenis != JenisTransaksi.pengeluaran) continue;
    final tanggal = DateTime(t.tanggal.year, t.tanggal.month, t.tanggal.day);
    if (tanggal.isBefore(awal) || tanggal.isAfter(akhir)) continue;
    final id = t.kategoriId ?? '';
    perKategori[id] = (perKategori[id] ?? 0) + t.nominal;
  }

  final total = perKategori.values.fold<int>(0, (a, b) => a + b);
  if (total == 0) return const [];

  final hasil = perKategori.entries.map((e) {
    final kategori = petaKategori[e.key];
    return DistribusiKategori(
      kategoriId: e.key,
      nama: kategori?.nama ?? 'Tanpa kategori',
      total: e.value,
      persen: (e.value / total) * 100,
    );
  }).toList();
  hasil.sort((a, b) => b.total.compareTo(a.total));
  return hasil;
}

/// Nama bulan pendek untuk grafik, misalnya `Jan`, `Feb`.
String namaBulanSingkat(int bulan) {
  const nama = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  return nama[bulan - 1];
}