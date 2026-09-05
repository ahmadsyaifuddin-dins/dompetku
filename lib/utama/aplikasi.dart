import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../inti/tema/pengontrol_tema.dart';
import '../inti/tema/tema_gelap.dart';
import '../inti/tema/tema_terang.dart';
import 'rute.dart';

class AplikasiDompetKu extends StatelessWidget {
  const AplikasiDompetKu({super.key});

  @override
  Widget build(BuildContext context) {
    final pengontrolTema = Get.find<PengontrolTema>();

    return Obx(
      () => GetMaterialApp(
        title: 'DompetKu',
        debugShowCheckedModeBanner: false,
        initialRoute: Rute.halamanInduk,
        getPages: Rute.pages,
        theme: temaTerangBuild(),
        darkTheme: temaGelapBuild(),
        themeMode: pengontrolTema.themeMode,
      ),
    );
  }
}