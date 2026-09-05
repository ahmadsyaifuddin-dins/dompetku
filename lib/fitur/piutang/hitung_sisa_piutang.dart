import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';

class RingkasanPiutang {
  final PiutangData piutang;
  final int totalPinjaman;
  final int totalPembayaran;
  final int sisa;

  const RingkasanPiutang({
    required this.piutang,
    required this.totalPinjaman,
    required this.totalPembayaran,
    required this.sisa,
  });
}

List<RingkasanPiutang> ringkasSemuaPiutang(
  List<PiutangData> piutang,
  List<RiwayatPiutangData> riwayat,
) {
  final perId = <String, List<RiwayatPiutangData>>{};
  for (final r in riwayat) {
    perId.putIfAbsent(r.piutangId, () => []).add(r);
  }
  return piutang.map((p) {
    final sisa = hitungSisaPiutang(perId[p.id] ?? const []);
    return RingkasanPiutang(
      piutang: p,
      totalPinjaman: sisa.$1,
      totalPembayaran: sisa.$2,
      sisa: sisa.$3,
    );
  }).toList();
}

(int totalPinjaman, int totalPembayaran, int sisa) hitungSisaPiutang(
  List<RiwayatPiutangData> riwayat,
) {
  var totalPinjaman = 0;
  var totalPembayaran = 0;
  for (final r in riwayat) {
    switch (r.jenis) {
      case JenisRiwayat.pinjaman:
      case JenisRiwayat.tambahan:
        totalPinjaman += r.nominal;
      case JenisRiwayat.pembayaran:
        totalPembayaran += r.nominal;
    }
  }
  return (totalPinjaman, totalPembayaran, totalPinjaman - totalPembayaran);
}

/// Sisa piutang = total pinjaman + total tambahan - total pembayaran.
int hitungSisaPiutangNominal(List<RiwayatPiutangData> riwayat) {
  return hitungSisaPiutang(riwayat).$3;
}