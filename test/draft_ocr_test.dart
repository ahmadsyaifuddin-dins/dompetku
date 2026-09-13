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

  group('parseNominalOCR', () {
    test('membaca nominal berawalan Rp dalam berbagai bentuk', () {
      expect(parseNominalOCR('Rp 75.000,00'), 75000);
      expect(parseNominalOCR('Rp75.000'), 75000);
      expect(parseNominalOCR('Total Rp1.500.000'), 1500000);
      expect(parseNominalOCR('+ Rp 50.000'), 50000);
    });

    test('mengabaikan nomor telepon tanpa Rp', () {
      expect(parseNominalOCR('Dari 081234567890 ke 081298765432'), isNull);
    });

    test('lebih mengutamakan baris jumlah transaksi daripada saldo', () {
      final teks = '''
        NILAI TRANSAKSI
        Rp 75.000,00
        SALDO TERSEDIA
        Rp 2.000.000,00
      ''';
      expect(parseNominalOCR(teks), 75000);
    });
  });

  group('ekstrakDraftDariTeks dari teks mentah OCR', () {
    test('membaca tangkapan layar transfer bank', () {
      final draft = ekstrakDraftDariTeks('''
        TRANSFER
        BNI
        Dari : 081234567890
        REK TABUNGAN
        17/09/2026 14:33
        Rp 75.000,00
      ''');

      expect(draft, isNotNull);
      expect(draft!.jenis, JenisTransaksi.pengeluaran);
      expect(draft.nominal, 75000);
      expect(draft.tanggal, DateTime(2026, 9, 17));
    });

    test('membaca terima kasih transfer masuk', () {
      final draft = ekstrakDraftDariTeks('''
        TRANSFER MASUK
        Dari: WARUNG SEHAT
        Rp 1.000.000
        20/09/2026
      ''');

      expect(draft, isNotNull);
      expect(draft!.jenis, JenisTransaksi.pemasukan);
      expect(draft.nominal, 1000000);
      expect(draft.merchant, 'WARUNG SEHAT');
      expect(draft.tanggal, DateTime(2026, 9, 20));
    });

    test('membaca pembayaran QRIS GoPay', () {
      final draft = ekstrakDraftDariTeks('''
        Pembayaran Berhasil
        Ke: Alfamart
        Transaksi: PAY-123456789
        Rp 25.000
        Waktu: 05/09/2026 08:12
      ''');

      expect(draft, isNotNull);
      expect(draft!.jenis, JenisTransaksi.pengeluaran);
      expect(draft.nominal, 25000);
      expect(draft.merchant, 'Alfamart');
      expect(draft.tanggal, DateTime(2026, 9, 5));
    });

    test('membaca top up e-wallet sebagai pemasukan', () {
      final draft = ekstrakDraftDariTeks('''
        TOP UP GOPAY
        + Rp 50.000
        01/09/2026
      ''');

      expect(draft, isNotNull);
      expect(draft!.jenis, JenisTransaksi.pemasukan);
      expect(draft.nominal, 50000);
    });
  });

  group('buatDraftTeksMentah', () {
    test('tetap menghasilkan draft tanpa nominal', () {
      final draft = buatDraftTeksMentah('''
        TERIMA KASIH
        Atas pembayaran Anda
      ''');

      expect(draft.nominal, 0);
      expect(draft.jenis, JenisTransaksi.pengeluaran);
    });
  });
}