import 'package:get/get.dart';

import '../data/database/database.dart';
import '../data/repositori/repositori_akun_dana.dart';
import '../data/repositori/repositori_kategori.dart';
import '../data/repositori/repositori_transaksi.dart';
import '../data/repositori/repositori_transfer.dart';
import '../inti/layanan/layanan_preferensi.dart';
import '../inti/layanan/layanan_saldo.dart';
import '../inti/tema/pengontrol_tema.dart';

class Dependensi {
  static Future<void> inisialisasi() async {
    await Get.putAsync(() => LayananPreferensi.buat());

    final database = DompetKuDatabase();
    Get.put<DompetKuDatabase>(database);
    Get.put<RepositoriAkunDana>(RepositoriAkunDana(database));
    Get.put<RepositoriKategori>(RepositoriKategori(database));
    Get.put<RepositoriTransaksi>(RepositoriTransaksi(database));
    Get.put<RepositoriTransfer>(RepositoriTransfer(database));
    Get.put<PengontrolTema>(PengontrolTema(Get.find<LayananPreferensi>()));

    final layananSaldo = Get.put<LayananSaldo>(
      LayananSaldo(
        repositoriAkun: Get.find<RepositoriAkunDana>(),
        repositoriKategori: Get.find<RepositoriKategori>(),
        repositoriTransaksi: Get.find<RepositoriTransaksi>(),
        repositoriTransfer: Get.find<RepositoriTransfer>(),
      ),
    );
    layananSaldo.mulai();
  }
}