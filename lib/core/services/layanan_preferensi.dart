import '../../data/model/enum_dompetku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayananPreferensi {
  static const String _kunciTema = 'mode_tema';
  static const String _awalanKunciKategoriBawaan = 'kategori_bawaan';

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

  static String _kunciKategoriBawaan(JenisTransaksi jenis) =>
      '${_awalanKunciKategoriBawaan}_${jenis.nama}';

  String? ambilKategoriBawaan(JenisTransaksi jenis) {
    return _preferensi.getString(_kunciKategoriBawaan(jenis));
  }

  Future<void> simpanKategoriBawaan(
    JenisTransaksi jenis,
    String kategoriId,
  ) async {
    await _preferensi.setString(_kunciKategoriBawaan(jenis), kategoriId);
  }

  Future<void> hapusKategoriBawaan(JenisTransaksi jenis) async {
    await _preferensi.remove(_kunciKategoriBawaan(jenis));
  }
}