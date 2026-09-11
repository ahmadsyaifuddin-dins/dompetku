import 'package:dompetku/data/database/database.dart';
import 'package:dompetku/data/model/enum_dompetku.dart';
import 'package:dompetku/fitur/piutang/hitung_sisa_piutang.dart';
import 'package:dompetku/core/utils/hitung_saldo.dart';
import 'package:flutter_test/flutter_test.dart';

RiwayatPiutangData _riwayat({
  required String id,
  required String piutangId,
  required JenisRiwayat jenis,
  required int nominal,
  String? akunId,
}) {
  return RiwayatPiutangData(
    id: id,
    piutangId: piutangId,
    jenis: jenis,
    nominal: nominal,
    akunDanaId: akunId,
    tanggal: DateTime(2026),
    catatan: null,
    dibuatPada: DateTime(2026),
  );
}

void main() {
  group('hitungSisaPiutang', () {
    test('mengikuti contoh skenario pada PRD', () {
      final riwayat = [
        _riwayat(
          id: '1',
          piutangId: 'p',
          jenis: JenisRiwayat.pinjaman,
          nominal: 500000,
        ),
        _riwayat(
          id: '2',
          piutangId: 'p',
          jenis: JenisRiwayat.tambahan,
          nominal: 200000,
        ),
        _riwayat(
          id: '3',
          piutangId: 'p',
          jenis: JenisRiwayat.pembayaran,
          nominal: 300000,
        ),
      ];

      final (pinjaman, pembayaran, sisa) = hitungSisaPiutang(riwayat);

      expect(pinjaman, 700000);
      expect(pembayaran, 300000);
      expect(sisa, 400000);
    });

    test('tanpa riwayat sisa nol', () {
      expect(hitungSisaPiutang([]).$3, 0);
    });
  });

  group('hitungSaldoAkun dengan riwayat piutang', () {
    test('pinjaman mengurangi saldo dan pembayaran menambah saldo', () {
      final akun = _akun('a', 'SeaBank', saldoAwal: 1000000);
      final riwayat = [
        _riwayat(
          id: '1',
          piutangId: 'p',
          jenis: JenisRiwayat.pinjaman,
          nominal: 500000,
          akunId: 'a',
        ),
        _riwayat(
          id: '2',
          piutangId: 'p',
          jenis: JenisRiwayat.tambahan,
          nominal: 200000,
          akunId: 'a',
        ),
        _riwayat(
          id: '3',
          piutangId: 'p',
          jenis: JenisRiwayat.pembayaran,
          nominal: 300000,
          akunId: 'a',
        ),
      ];

      final saldo = hitungSaldoAkun(
        saldoAwal: akun.saldoAwal,
        idAkun: akun.id,
        riwayatPiutang: riwayat,
      );

      expect(saldo, 600000);
    });

    test('tidak memengaruhi akun yang tidak dipakai', () {
      final akun = _akun('a', 'SeaBank', saldoAwal: 100000);
      final riwayat = [
        _riwayat(
          id: '1',
          piutangId: 'p',
          jenis: JenisRiwayat.pinjaman,
          nominal: 50000,
          akunId: 'b',
        ),
      ];

      final saldo = hitungSaldoAkun(
        saldoAwal: akun.saldoAwal,
        idAkun: akun.id,
        riwayatPiutang: riwayat,
      );

      expect(saldo, 100000);
    });
  });
}

AkunDanaData _akun(String id, String nama, {int saldoAwal = 0}) {
  return AkunDanaData(
    id: id,
    nama: nama,
    jenis: JenisAkun.bank,
    saldoAwal: saldoAwal,
    ikon: null,
    aktif: true,
    dibuatPada: DateTime(2026),
    diperbaruiPada: DateTime(2026),
  );
}