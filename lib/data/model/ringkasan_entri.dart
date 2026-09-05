import '../database/database.dart';

class RingkasanTransaksi {
  final TransaksiData transaksi;
  final AkunDanaData akun;
  final KategoriData? kategori;

  const RingkasanTransaksi({
    required this.transaksi,
    required this.akun,
    this.kategori,
  });
}

class RingkasanTransfer {
  final TransferData transfer;
  final AkunDanaData akunAsal;
  final AkunDanaData akunTujuan;

  const RingkasanTransfer({
    required this.transfer,
    required this.akunAsal,
    required this.akunTujuan,
  });
}

enum JenisEntri { pemasukan, pengeluaran, transfer }

class EntriHistori {
  final String id;
  final JenisEntri jenis;
  final int nominal;
  final DateTime tanggal;
  final String label;
  final String namaAkun;
  final String? namaAkunLawan;
  final String? catatan;
  final String akunDanaId;
  final String? kategoriId;

  const EntriHistori({
    required this.id,
    required this.jenis,
    required this.nominal,
    required this.tanggal,
    required this.label,
    required this.namaAkun,
    this.namaAkunLawan,
    this.catatan,
    required this.akunDanaId,
    this.kategoriId,
  });
}