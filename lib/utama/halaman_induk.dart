import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../fitur/beranda/halaman_beranda.dart';
import '../fitur/pengaturan/halaman_pengaturan.dart';
import '../fitur/piutang/halaman_piutang.dart';
import '../fitur/transaksi/halaman_transaksi.dart';
import 'kontrol_induk.dart';

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
        bottomNavigationBar: NavigationBar(
          selectedIndex: indeks,
          onDestinationSelected: kontrol.ubahIndeks,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'Transaksi',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_alt_outlined),
              selectedIcon: Icon(Icons.people_alt_rounded),
              label: 'Piutang',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Pengaturan',
            ),
          ],
        ),
      );
    });
  }
}