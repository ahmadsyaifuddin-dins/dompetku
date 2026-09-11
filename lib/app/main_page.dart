import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../fitur/beranda/halaman_beranda.dart';
import '../fitur/pengaturan/halaman_pengaturan.dart';
import '../fitur/piutang/halaman_piutang.dart';
import '../fitur/transaksi/halaman_transaksi.dart';
import '../komponen/navigasi/bilah_navigasi.dart';
import 'main_controller.dart';
import 'routes.dart';

class HalamanInduk extends StatelessWidget {
  final int indeksAwal;

  const HalamanInduk({super.key, this.indeksAwal = 0});

  @override
  Widget build(BuildContext context) {
    final kontrol = Get.isRegistered<KontrolInduk>()
        ? Get.find<KontrolInduk>()
        : Get.put(KontrolInduk());
    if (indeksAwal > 0) kontrol.ubahIndeks(indeksAwal);

    return Obx(() {
      final indeks = kontrol.indeks.value;
      return Scaffold(
        body: IndexedStack(
          index: indeks,
          children: const [
            HalamanBeranda(),
            HalamanTransaksi(),
            HalamanPiutang(),
            HalamanPengaturan(),
          ],
        ),
        bottomNavigationBar: BilahNavigasiDompetku(
          indeks: indeks,
          padaPilih: kontrol.ubahIndeks,
          padaBacaGambar: () => Get.toNamed(Rute.bacaGambar),
        ),
      );
    });
  }
}