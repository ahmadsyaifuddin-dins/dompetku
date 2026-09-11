import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../data/model/ringkasan_entri.dart';

/// Menggabungkan transaksi dan transfer menjadi satu daftar histori
/// yang diurutkan dari yang paling baru.
List<EntriHistori> gabungEntriHistori({
  required Map<String, AkunDanaData> akun,
  required Map<String, KategoriData> kategori,
  required List<TransaksiData> transaksi,
  required List<TransferData> transfer,
}) {
  final daftar = <EntriHistori>[];

  for (final t in transaksi) {
    final dataAkun = akun[t.akunDanaId];
    final jenis = switch (t.jenis) {
      JenisTransaksi.pemasukan => JenisEntri.pemasukan,
      JenisTransaksi.pengeluaran => JenisEntri.pengeluaran,
    };
    daftar.add(
      EntriHistori(
        id: t.id,
        jenis: jenis,
        nominal: t.nominal,
        tanggal: t.tanggal,
        label: kategori[t.kategoriId]?.nama ?? 'Tanpa kategori',
        namaAkun: dataAkun?.nama ?? 'Akun tidak ditemukan',
        catatan: t.catatan,
        akunDanaId: t.akunDanaId,
        kategoriId: t.kategoriId,
      ),
    );
  }

  for (final tr in transfer) {
    final asal = akun[tr.akunAsalId];
    final tujuan = akun[tr.akunTujuanId];
    daftar.add(
      EntriHistori(
        id: tr.id,
        jenis: JenisEntri.transfer,
        nominal: tr.nominal,
        tanggal: tr.tanggal,
        label: 'Transfer',
        namaAkun: asal?.nama ?? 'Akun tidak ditemukan',
        namaAkunLawan: tujuan?.nama ?? 'Akun tidak ditemukan',
        catatan: tr.catatan,
        akunDanaId: tr.akunAsalId,
      ),
    );
  }

  daftar.sort((a, b) => b.tanggal.compareTo(a.tanggal));
  return daftar;
}