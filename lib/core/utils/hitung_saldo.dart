import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';

const int _saldoAwal = 0;

/// Menghitung saldo sebuah akun dari saldo awal, transaksi, transfer,
/// dan pinjaman/pembayaran piutang.
///
/// Pemasukan menambah saldo, pengeluaran mengurangi saldo.
/// Transfer keluar mengurangi saldo, transfer masuk menambah saldo.
/// Pinjaman dan tambahan piutang mengurangi saldo akun debit,
/// pembayaran piutang menambah saldo akun kredit.
int hitungSaldoAkun({
  required int saldoAwal,
  required String idAkun,
  List<TransaksiData> transaksi = const [],
  List<TransferData> transfer = const [],
  List<RiwayatPiutangData> riwayatPiutang = const [],
}) {
  var saldo = saldoAwal;
  for (final t in transaksi) {
    if (t.akunDanaId != idAkun) continue;
    switch (t.jenis) {
      case JenisTransaksi.pemasukan:
        saldo += t.nominal;
      case JenisTransaksi.pengeluaran:
        saldo -= t.nominal;
    }
  }
  for (final tr in transfer) {
    if (tr.akunAsalId == idAkun) saldo -= tr.nominal;
    if (tr.akunTujuanId == idAkun) saldo += tr.nominal;
  }
  for (final rp in riwayatPiutang) {
    if (rp.akunDanaId != idAkun) continue;
    switch (rp.jenis) {
      case JenisRiwayat.pembayaran:
        saldo += rp.nominal;
      case JenisRiwayat.pinjaman:
      case JenisRiwayat.tambahan:
        saldo -= rp.nominal;
    }
  }
  return saldo;
}

/// Menghitung total saldo gabungan semua akun.
int hitungTotalSaldo(
  List<AkunDanaData> akun,
  List<TransaksiData> transaksi,
  List<TransferData> transfer, [
  List<RiwayatPiutangData> riwayatPiutang = const [],
]) {
  var total = _saldoAwal;
  final akunAktif = akun.where((a) => a.aktif).toList();
  for (final a in akunAktif) {
    total += hitungSaldoAkun(
      saldoAwal: a.saldoAwal,
      idAkun: a.id,
      transaksi: transaksi,
      transfer: transfer,
      riwayatPiutang: riwayatPiutang,
    );
  }
  return total;
}