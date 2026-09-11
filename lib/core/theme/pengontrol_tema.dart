import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/enum_dompetku.dart';
import '../services/layanan_preferensi.dart';

class PengontrolTema extends GetxController {
  final LayananPreferensi _layananPreferensi;

  final _modeTema = ModeTema.system.obs;
  ModeTema get modeTema => _modeTema.value;

  PengontrolTema(this._layananPreferensi);

  ThemeMode get themeMode {
    switch (_modeTema.value) {
      case ModeTema.system:
        return ThemeMode.system;
      case ModeTema.terang:
        return ThemeMode.light;
      case ModeTema.gelap:
        return ThemeMode.dark;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _modeTema.value = _layananPreferensi.ambilModeTema();
  }

  Future<void> aturModeTema(ModeTema mode) async {
    if (_modeTema.value == mode) return;
    _modeTema.value = mode;
    await _layananPreferensi.simpanModeTema(mode);
  }
}