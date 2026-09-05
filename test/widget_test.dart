import 'package:dompetku/data/database/database.dart';
import 'package:dompetku/data/model/enum_dompetku.dart';
import 'package:dompetku/data/repositori/repositori_akun_dana.dart';
import 'package:dompetku/data/repositori/repositori_kategori.dart';
import 'package:dompetku/data/repositori/repositori_piutang.dart';
import 'package:dompetku/data/repositori/repositori_transaksi.dart';
import 'package:dompetku/data/repositori/repositori_transfer.dart';
import 'package:dompetku/inti/layanan/layanan_preferensi.dart';
import 'package:dompetku/inti/layanan/layanan_saldo.dart';
import 'package:dompetku/inti/tema/pengontrol_tema.dart';
import 'package:dompetku/inti/utilitas/format_rupiah.dart';
import 'package:dompetku/utama/aplikasi.dart';
import 'package:dompetku/utama/kontrol_induk.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> aturLingkunganUji() async {
  Get.reset();
  SharedPreferences.setMockInitialValues({});
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  await initializeDateFormatting('id_ID', null);
}

class LingkunganUji {
  final Widget aplikasi;
  final DompetKuDatabase database;

  LingkunganUji({required this.aplikasi, required this.database});
}

Future<LingkunganUji> buatLingkunganUji() async {
  await aturLingkunganUji();
  final database = DompetKuDatabase(NativeDatabase.memory());
  final preferensi = await SharedPreferences.getInstance();

  Get.put<DompetKuDatabase>(database);
  Get.put<RepositoriAkunDana>(RepositoriAkunDana(database));
  Get.put<RepositoriKategori>(RepositoriKategori(database));
  Get.put<RepositoriTransaksi>(RepositoriTransaksi(database));
  Get.put<RepositoriTransfer>(RepositoriTransfer(database));
  Get.put<RepositoriPiutang>(RepositoriPiutang(database));
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

  return LingkunganUji(
    aplikasi: const AplikasiDompetKu(),
    database: database,
  );
}

void main() {
  group('Utilitas', () {
    test('formatRupiah memformat nominal dengan benar', () {
      expect(formatRupiah(500000), 'Rp500.000');
      expect(formatRupiah(0), 'Rp0');
      expect(formatRupiah(12500), 'Rp12.500');
    });
  });

  group('PengontrolTema', () {
    test('mode tema default adalah system', () async {
      await aturLingkunganUji();
      final preferensi = await SharedPreferences.getInstance();
      final pengontrol = PengontrolTema(LayananPreferensi(preferensi));

      expect(pengontrol.modeTema, ModeTema.system);
      expect(pengontrol.themeMode, ThemeMode.system);
    });

    test('aturModeTema menyimpan dan mengubah themeMode', () async {
      await aturLingkunganUji();
      final preferensi = await SharedPreferences.getInstance();
      final pengontrol = PengontrolTema(LayananPreferensi(preferensi));

      await pengontrol.aturModeTema(ModeTema.gelap);

      expect(pengontrol.modeTema, ModeTema.gelap);
      expect(pengontrol.themeMode, ThemeMode.dark);
    });
  });

  group('RepositoriAkunDana', () {
    test('database baru memiliki SeaBank sebagai akun default', () async {
      final database = DompetKuDatabase(NativeDatabase.memory());
      final repositori = RepositoriAkunDana(database);

      final akun = await repositori.ambilSemuaAktif();

      expect(akun, hasLength(1));
      expect(akun.first.nama, 'SeaBank');
      expect(akun.first.jenis, JenisAkun.bank);
      expect(akun.first.aktif, isTrue);

      await database.close();
    });

    test('nonaktifkan mengubah status aktif menjadi false', () async {
      final database = DompetKuDatabase(NativeDatabase.memory());
      final repositori = RepositoriAkunDana(database);

      final akun = await repositori.ambilSemuaAktif();
      await repositori.nonaktifkan(akun.first.id);

      final tersisa = await repositori.ambilSemuaAktif();
      expect(tersisa, isEmpty);

      await database.close();
    });
  });

  group('Widget', () {
    testWidgets('beranda menampilkan saldo dari akun default',
        (tester) async {
      final lingkungan = await buatLingkunganUji();
      await tester.pumpWidget(lingkungan.aplikasi);
      await tester.pumpAndSettle();

      expect(find.text('Total Saldo'), findsOneWidget);
      expect(find.text('Akun Dana'), findsOneWidget);
      expect(find.text('SeaBank'), findsOneWidget);
      expect(find.text('Rp0'), findsNWidgets(2));

      await lingkungan.database.close();
      await tester.pump();
    });

    testWidgets('indeks navigasi menampilkan halaman pengaturan',
        (tester) async {
      final lingkungan = await buatLingkunganUji();
      await tester.pumpWidget(lingkungan.aplikasi);
      await tester.pumpAndSettle();

      final kontrol = Get.find<KontrolInduk>();
      kontrol.ubahIndeks(3);
      await tester.pumpAndSettle();

      expect(kontrol.indeks.value, 3);

      final navigasi =
          tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navigasi.selectedIndex, 3);
      expect(find.text('Tampilan'), findsOneWidget);

      await lingkungan.database.close();
      await tester.pump();
    });

    testWidgets('perubahan tema mencerminkan mode gelap pada aplikasi',
        (tester) async {
      final lingkungan = await buatLingkunganUji();
      await tester.pumpWidget(lingkungan.aplikasi);
      await tester.pumpAndSettle();

      final pengontrolTema = Get.find<PengontrolTema>();
      await pengontrolTema.aturModeTema(ModeTema.gelap);
      await tester.pumpAndSettle();

      final aplikasi =
          tester.widget<GetMaterialApp>(find.byType(GetMaterialApp));
      expect(aplikasi.themeMode, ThemeMode.dark);

      await lingkungan.database.close();
      await tester.pump();
    });

    testWidgets('menambah akun dana melalui halaman Akun Dana',
        (tester) async {
      final lingkungan = await buatLingkunganUji();
      await tester.pumpWidget(lingkungan.aplikasi);
      await tester.pumpAndSettle();

      Get.find<KontrolInduk>().ubahIndeks(3);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Akun Dana'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tambah'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Cash');
      await tester.enterText(find.byType(TextField).at(1), '500000');
      await tester.tap(find.text('Simpan Akun'));
      await tester.pumpAndSettle();

      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Rp500.000'), findsOneWidget);

      final layananSaldo = Get.find<LayananSaldo>();
      expect(layananSaldo.totalSaldo, 500000);

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      await lingkungan.database.close();
      await tester.pump();
    });

    testWidgets('menambah pengeluaran mengubah total saldo', (tester) async {
      final lingkungan = await buatLingkunganUji();
      await tester.pumpWidget(lingkungan.aplikasi);
      await tester.pumpAndSettle();

      Get.find<KontrolInduk>().ubahIndeks(1);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Catat'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pengeluaran').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), '100000');
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownMenuItem<String>).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Simpan Pengeluaran'));
      await tester.pumpAndSettle();

      final layananSaldo = Get.find<LayananSaldo>();
      expect(layananSaldo.totalSaldo, -100000);
      expect(layananSaldo.pemuatan.value, isFalse);

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      await lingkungan.database.close();
      await tester.pump();
    });
  });
}