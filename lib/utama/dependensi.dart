import 'package:get/get.dart';

import '../data/database/database.dart';
import '../data/repositori/repositori_akun_dana.dart';
import '../inti/layanan/layanan_preferensi.dart';
import '../inti/tema/pengontrol_tema.dart';

class Dependensi {
  static Future<void> inisialisasi() async {
    await Get.putAsync(() => LayananPreferensi.buat());

    Get.put<DompetKuDatabase>(DompetKuDatabase());
    Get.put<RepositoriAkunDana>(
      RepositoriAkunDana(Get.find<DompetKuDatabase>()),
    );
    Get.put<PengontrolTema>(PengontrolTema(Get.find<LayananPreferensi>()));
  }
}