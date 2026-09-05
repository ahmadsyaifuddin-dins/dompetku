import 'package:get/get.dart';

import '../../data/model/ringkasan_entri.dart';
import '../../inti/layanan/layanan_saldo.dart';

class HistoriController extends GetxController {
  final LayananSaldo layananSaldo;
  final filter = Rxn<JenisEntri>();

  HistoriController({required this.layananSaldo});

  List<EntriHistori> get histori {
    final nilai = filter.value;
    if (nilai == null) return layananSaldo.histori;
    return layananSaldo.histori
        .where((entri) => entri.jenis == nilai)
        .toList();
  }
}