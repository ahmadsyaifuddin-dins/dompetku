import '../../data/model/enum_dompetku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayananPreferensi {
  static const String _kunciTema = 'mode_tema';
  static const String _awalanKunciKategoriBawaan = 'kategori_bawaan';
  static const String _kunciSudahInstal = 'sudah_instal';
  static const String _kunciNamaPengguna = 'nama_pengguna';
  static const String _kunciNomorPengguna = 'nomor_pengguna';

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

  bool get sudahInstal => _preferensi.getBool(_kunciSudahInstal) ?? false;

  String? get namaPengguna => _preferensi.getString(_kunciNamaPengguna);

  String? get nomorPengguna => _preferensi.getString(_kunciNomorPengguna);

  Future<void> simpanProfil({
    required String nama,
    required String nomor,
  }) async {
    await _preferensi.setString(_kunciNamaPengguna, nama);
    await _preferensi.setString(_kunciNomorPengguna, nomor);
    await _preferensi.setBool(_kunciSudahInstal, true);
  }

  Future<void> tandaiSudahInstal() async {
    await _preferensi.setBool(_kunciSudahInstal, true);
  }
}