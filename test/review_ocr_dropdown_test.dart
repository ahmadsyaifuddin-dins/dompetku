import 'package:dompetku/app/app.dart';
import 'package:dompetku/app/routes.dart';
import 'package:dompetku/core/services/layanan_fonnte.dart';
import 'package:dompetku/core/services/layanan_preferensi.dart';
import 'package:dompetku/core/services/layanan_saldo.dart';
import 'package:dompetku/core/theme/pengontrol_tema.dart';
import 'package:dompetku/data/database/database.dart';
import 'package:dompetku/data/repositori/repositori_akun_dana.dart';
import 'package:dompetku/data/repositori/repositori_kategori.dart';
import 'package:dompetku/data/repositori/repositori_piutang.dart';
import 'package:dompetku/data/repositori/repositori_transaksi.dart';
import 'package:dompetku/data/repositori/repositori_transfer.dart';
import 'package:dompetku/fitur/transaksi/draft_transaksi_ocr.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<DompetKuDatabase> _siapkanLingkungan() async {
  Get.reset();
  SharedPreferences.setMockInitialValues({'sudah_instal': true});
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  await initializeDateFormatting('id_ID', null);

  final database = DompetKuDatabase(NativeDatabase.memory());
  Get.put<DompetKuDatabase>(database);
  Get.put<RepositoriAkunDana>(RepositoriAkunDana(database));
  Get.put<RepositoriKategori>(RepositoriKategori(database));
  Get.put<RepositoriTransaksi>(RepositoriTransaksi(database));
  Get.put<RepositoriTransfer>(RepositoriTransfer(database));
  Get.put<RepositoriPiutang>(RepositoriPiutang(database));
  Get.put<LayananFonnte>(LayananFonnte());
  final preferensi = await SharedPreferences.getInstance();
  Get.put<LayananPreferensi>(LayananPreferensi(preferensi));
  Get.put<PengontrolTema>(PengontrolTema(Get.find<LayananPreferensi>()));

  final layananSaldo = Get.put<LayananSaldo>(
    LayananSaldo(
      repositoriAkun: Get.find<RepositoriAkunDana>(),
      repositoriKategori: Get.find<RepositoriKategori>(),
      repositoriTransaksi: Get.find<RepositoriTransaksi>(),
      repositoriTransfer: Get.find<RepositoriTransfer>(),
      repositoriPiutang: Get.find<RepositoriPiutang>(),
    ),
  );
  layananSaldo.mulai();
  return database;
}

void main() {
  testWidgets('Review OCR: dropdown akun dan kategori bisa dipilih',
      (tester) async {
    final database = await _siapkanLingkungan();
    addTearDown(database.close);

    final draft = ekstrakDraftDariTeks('''
      Jenis: Pengeluaran
      Nominal: Rp75.000
      Tanggal: 5 September 2026
      Merchant: Contoh Merchant
      Metode: SeaBank
      Catatan: Pembayaran
    ''')!;

    await tester.pumpWidget(const AplikasiDompetKu());
    await tester.pumpAndSettle();

    Get.toNamed(Rute.reviewOCR, arguments: draft);
    await tester.pumpAndSettle();

    expect(find.text('Tinjau Transaksi'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(2));

    // Dropdown Kategori terbuka dan berisi item.
    final dropdownKategori =
        find.byType(DropdownButtonFormField<String>).at(1);
    await tester.ensureVisible(dropdownKategori);
    await tester.pumpAndSettle();
    await tester.tap(dropdownKategori);
    await tester.pumpAndSettle();

    final itemKategori = find.byType(DropdownMenuItem<String>).last;
    final namaItem = tester
        .widget<DropdownMenuItem<String>>(itemKategori)
        .child as Text;
    expect(itemKategori, findsOneWidget);

    await tester.tap(itemKategori);
    await tester.pumpAndSettle();

    // Nilai terpilih tampil sebagai teks nama di dalam field Kategori.
    expect(find.text(namaItem.data!), findsWidgets);

    // Dropdown Akun Dana terbuka dan berisi item.
    final dropdownAkun = find.byType(DropdownButtonFormField<String>).first;
    await tester.ensureVisible(dropdownAkun);
    await tester.pumpAndSettle();
    await tester.tap(dropdownAkun);
    await tester.pumpAndSettle();

    final itemAkun = find.byType(DropdownMenuItem<String>).last;
    final namaAkun = tester.widget<DropdownMenuItem<String>>(itemAkun).child as Text;
    expect(itemAkun, findsOneWidget);
    await tester.tap(itemAkun);
    await tester.pumpAndSettle();

    // Nilai terpilih tampil di dalam field Akun Dana.
    expect(find.text(namaAkun.data!), findsWidgets);
  });
}