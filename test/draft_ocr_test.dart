import 'package:dompetku/data/model/enum_dompetku.dart';
import 'package:dompetku/fitur/transaksi/draft_transaksi_ocr.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ekstrakDraftDariTeks', () {
    test('mengubah contoh teks menjadi draft transaksi', () {
      final draft = ekstrakDraftDariTeks(contohTeksOCR);

      expect(draft, isNotNull);
      expect(draft!.jenis, JenisTransaksi.pengeluaran);
      expect(draft.nominal, 75000);
      expect(draft.tanggal, DateTime(2026, 9, 5));
      expect(draft.merchant, 'Contoh Merchant');
      expect(draft.metode, 'SeaBank');
      expect(draft.catatan, 'Pembayaran');
    });

    test('membaca jenis pemasukan', () {
      final draft = ekstrakDraftDariTeks('''
        Jenis: Pemasukan
        Nominal: Rp500.000
        Tanggal: 2026-09-01
      ''');

      expect(draft, isNotNull);
      expect(draft!.jenis, JenisTransaksi.pemasukan);
    });

    test('membaca tanggal dalam berbagai format', () {
      expect(
        ekstrakDraftDariTeks('Nominal: Rp1.000\nTanggal: 01/09/2026')!.tanggal,
        DateTime(2026, 9, 1),
      );
      expect(
        ekstrakDraftDariTeks('Nominal: Rp1.000\nTanggal: 2026-09-02')!.tanggal,
        DateTime(2026, 9, 2),
      );
    });

    test('mengembalikan null saat nominal tidak terbaca', () {
      expect(
        ekstrakDraftDariTeks('Jenis: Pengeluaran\nTanggal: 2026-09-01'),
        isNull,
      );
    });

    test('tidak membaca lebar nol', () {
      expect(ekstrakDraftDariTeks(''), isNull);
    });
  });

  test('buatDraftContoh selalu menghasilkan draft', () {
    expect(buatDraftContoh().nominal, 75000);
    expect(buatDraftContoh().tanggal, DateTime(2026, 9, 5));
  });
}