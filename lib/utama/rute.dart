import 'package:get/get.dart';

import '../fitur/beranda/halaman_beranda.dart';
import '../fitur/pengaturan/halaman_pengaturan.dart';
import '../fitur/piutang/halaman_piutang.dart';
import '../fitur/transaksi/halaman_transaksi.dart';
import 'halaman_induk.dart';

class Rute {
  Rute._();

  static const String halamanInduk = '/';
  static const String beranda = '/beranda';
  static const String transaksi = '/transaksi';
  static const String piutang = '/piutang';
  static const String pengaturan = '/pengaturan';

  static final pages = [
    GetPage(
      name: halamanInduk,
      page: () => const HalamanInduk(),
    ),
    GetPage(
      name: beranda,
      page: () => const HalamanBeranda(),
    ),
    GetPage(
      name: transaksi,
      page: () => const HalamanTransaksi(),
    ),
    GetPage(
      name: piutang,
      page: () => const HalamanPiutang(),
    ),
    GetPage(
      name: pengaturan,
      page: () => const HalamanPengaturan(),
    ),
  ];
}