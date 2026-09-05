import '../../data/model/enum_dompetku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayananPreferensi {
  static const String _kunciTema = 'mode_tema';

  final SharedPreferences _preferensi;

  LayananPreferensi(this._preferensi);

  static Future<LayananPreferensi> buat() async {
    final preferensi = await SharedPreferences.getInstance();
    return LayananPreferensi(preferensi);
  }

  ModeTema ambilModeTema() {
    final nama = _preferensi.getString(_kunciTema) ?? ModeTema.system.nama;
    return ModeTema.values.firstWhere(
      (mode) => mode.nama == nama,
      orElse: () => ModeTema.system,
    );
  }

  Future<void> simpanModeTema(ModeTema mode) async {
    await _preferensi.setString(_kunciTema, mode.nama);
  }
}