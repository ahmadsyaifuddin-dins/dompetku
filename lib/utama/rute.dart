import 'package:get/get.dart';

import '../fitur/akun_dana/halaman_akun_dana.dart';
import '../fitur/beranda/halaman_beranda.dart';
import '../fitur/kategori/halaman_kategori.dart';
import '../fitur/pengaturan/halaman_pengaturan.dart';
import '../fitur/pengaturan/halaman_tentang.dart';
import '../fitur/piutang/halaman_detail_piutang.dart';
import '../fitur/piutang/halaman_piutang.dart';
import '../fitur/piutang/halaman_tambah_piutang.dart';
import '../fitur/transaksi/halaman_baca_gambar.dart';
import '../fitur/transaksi/halaman_form_transaksi.dart';
import '../fitur/transaksi/halaman_form_transfer.dart';
import '../fitur/transaksi/halaman_review_ocr.dart';
import '../fitur/transaksi/halaman_transaksi.dart';
import 'halaman_induk.dart';

class Rute {
  Rute._();

  static const String halamanInduk = '/';
  static const String beranda = '/beranda';
  static const String transaksi = '/transaksi';
  static const String piutang = '/piutang';
  static const String pengaturan = '/pengaturan';

  static const String tambahTransaksi = '/tambah-transaksi';
  static const String tambahTransfer = '/tambah-transfer';
  static const String tambahPiutang = '/tambah-piutang';
  static const String detailPiutang = '/detail-piutang';
  static const String bacaGambar = '/baca-gambar';
  static const String reviewOCR = '/review-ocr';
  static const String akunDana = '/akun-dana';
  static const String kategori = '/kategori';
  static const String tentang = '/tentang';

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
    GetPage(
      name: tambahTransaksi,
      page: () => const HalamanFormTransaksi(),
    ),
    GetPage(
      name: tambahTransfer,
      page: () => const HalamanFormTransfer(),
    ),
    GetPage(
      name: tambahPiutang,
      page: () => const HalamanTambahPiutang(),
    ),
    GetPage(
      name: detailPiutang,
      page: () => const HalamanDetailPiutang(),
    ),
    GetPage(
      name: bacaGambar,
      page: () => const HalamanBacaGambar(),
    ),
    GetPage(
      name: reviewOCR,
      page: () => const HalamanReviewOCR(),
    ),
    GetPage(
      name: akunDana,
      page: () => const HalamanAkunDana(),
    ),
    GetPage(
      name: kategori,
      page: () => const HalamanKategori(),
    ),
    GetPage(
      name: tentang,
      page: () => const HalamanTentang(),
    ),
  ];
}