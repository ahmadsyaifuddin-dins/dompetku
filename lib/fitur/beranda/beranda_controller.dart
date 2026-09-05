import 'dart:async';

import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/repositori/repositori_akun_dana.dart';

class BerandaController extends GetxController {
  final RepositoriAkunDana _repositoriAkunDana;

  final akun = <AkunDanaData>[].obs;
  final loading = true.obs;
  final galat = false.obs;

  StreamSubscription<List<AkunDanaData>>? _langganan;

  BerandaController(this._repositoriAkunDana);

  int get totalSaldo =>
      akun.fold(0, (jumlah, data) => jumlah + data.saldoAwal);

  @override
  void onInit() {
    super.onInit();
    _mulaiPantau();
  }

  void _mulaiPantau() {
    _langganan = _repositoriAkunDana.pantauSemuaAktif().listen(
          (data) {
            akun.value = data;
            loading.value = false;
            galat.value = false;
          },
          onError: (_) {
            loading.value = false;
            galat.value = true;
          },
        );
  }

  void muatUlang() {
    loading.value = true;
    galat.value = false;
    _langganan?.cancel();
    _mulaiPantau();
  }

  @override
  void onClose() {
    _langganan?.cancel();
    super.onClose();
  }
}