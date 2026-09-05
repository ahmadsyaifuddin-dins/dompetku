import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/repositori/repositori_piutang.dart';
import '../../inti/layanan/layanan_saldo.dart';
import '../../utama/rute.dart';
import 'hitung_sisa_piutang.dart';

class PiutangController extends GetxController {
  final RepositoriPiutang repositoriPiutang;
  final LayananSaldo layananSaldo;

  final daftar = <RingkasanPiutang>[].obs;
  final pemuatan = true.obs;

  List<PiutangData> _piutang = const [];

  PiutangController({
    required this.repositoriPiutang,
    required this.layananSaldo,
  });

  @override
  void onInit() {
    super.onInit();
    repositoriPiutang.pantauSemua().listen((data) {
      _piutang = data;
      _gabung();
    });
    ever(layananSaldo.riwayatPiutang, (_) => _gabung());
  }

  void _gabung() {
    daftar.value = ringkasSemuaPiutang(
      _piutang,
      List.of(layananSaldo.riwayatPiutang),
    );
    pemuatan.value = false;
  }

  void muatUlang() {
    layananSaldo.muatUlang();
  }

  void bukaDetail(RingkasanPiutang item) {
    Get.toNamed(Rute.detailPiutang, arguments: item.piutang);
  }
}