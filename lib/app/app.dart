import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/pengontrol_tema.dart';
import '../core/theme/tema_gelap.dart';
import '../core/theme/tema_terang.dart';
import 'routes.dart';

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