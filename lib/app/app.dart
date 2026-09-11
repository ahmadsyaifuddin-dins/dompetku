import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/services/layanan_preferensi.dart';
import '../core/theme/pengontrol_tema.dart';
import '../core/theme/tema_gelap.dart';
import '../core/theme/tema_terang.dart';
import 'routes.dart';

class AplikasiDompetKu extends StatelessWidget {
  const AplikasiDompetKu({super.key});

  @override
  Widget build(BuildContext context) {
    final pengontrolTema = Get.find<PengontrolTema>();
    final sudahInstal = Get.find<LayananPreferensi>().sudahInstal;

    return Obx(
      () => GetMaterialApp(
        title: 'DompetKu',
        debugShowCheckedModeBanner: false,
        initialRoute: sudahInstal ? Rute.halamanInduk : Rute.onboarding,
        getPages: Rute.pages,
        theme: temaTerangBuild(),
        darkTheme: temaGelapBuild(),
        themeMode: pengontrolTema.themeMode,
      ),
    );
  }
}