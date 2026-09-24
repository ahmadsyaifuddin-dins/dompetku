import '../../data/model/enum_dompetku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayananPreferensi {
  static const String _kunciTema = 'mode_tema';
  static const String _awalanKunciKategoriBawaan =
      'kategori_bawaan';

  static const String _kunciSudahInstal = 'sudah_instal';
  static const String _kunciNamaPengguna = 'nama_pengguna';
  static const String _kunciNomorPengguna = 'nomor_pengguna';

  final SharedPreferences _preferensi;

  LayananPreferensi(this._preferensi);

  static Future<LayananPreferensi> buat() async {
    final preferensi =
        await SharedPreferences.getInstance();

    return LayananPreferensi(preferensi);
  }

  ModeTema ambilModeTema() {
    final nama =
        _preferensi.getString(_kunciTema) ??
        ModeTema.system.nama;

    return ModeTema.values.firstWhere(
      (mode) => mode.nama == nama,
      orElse: () => ModeTema.system,
    );
  }

  Future<void> simpanModeTema(
    ModeTema mode,
  ) async {
    final berhasil = await _preferensi.setString(
      _kunciTema,
      mode.nama,
    );

    if (!berhasil) {
      throw Exception(
        'Gagal menyimpan mode tema.',
      );
    }
  }

  static String _kunciKategoriBawaan(
    JenisTransaksi jenis,
  ) =>
      '${_awalanKunciKategoriBawaan}_${jenis.nama}';

  String? ambilKategoriBawaan(
    JenisTransaksi jenis,
  ) {
    return _preferensi.getString(
      _kunciKategoriBawaan(jenis),
    );
  }

  Future<void> simpanKategoriBawaan(
    JenisTransaksi jenis,
    String kategoriId,
  ) async {
    final berhasil = await _preferensi.setString(
      _kunciKategoriBawaan(jenis),
      kategoriId,
    );

    if (!berhasil) {
      throw Exception(
        'Gagal menyimpan kategori bawaan.',
      );
    }
  }

  Future<void> hapusKategoriBawaan(
    JenisTransaksi jenis,
  ) async {
    final berhasil = await _preferensi.remove(
      _kunciKategoriBawaan(jenis),
    );

    if (!berhasil) {
      throw Exception(
        'Gagal menghapus kategori bawaan.',
      );
    }
  }

  bool get sudahInstal =>
      _preferensi.getBool(_kunciSudahInstal) ?? false;

  String? get namaPengguna =>
      _preferensi.getString(_kunciNamaPengguna);

  String? get nomorPengguna =>
      _preferensi.getString(_kunciNomorPengguna);

  Future<void> simpanProfil({
    required String nama,
    required String nomor,
  }) async {
    final berhasilNama = await _preferensi.setString(
      _kunciNamaPengguna,
      nama,
    );

    if (!berhasilNama) {
      throw Exception(
        'Gagal menyimpan nama pengguna.',
      );
    }

    final berhasilNomor = await _preferensi.setString(
      _kunciNomorPengguna,
      nomor,
    );

    if (!berhasilNomor) {
      throw Exception(
        'Gagal menyimpan nomor pengguna.',
      );
    }

    final berhasilInstal = await _preferensi.setBool(
      _kunciSudahInstal,
      true,
    );

    if (!berhasilInstal) {
      throw Exception(
        'Gagal menyimpan status sudah_instal.',
      );
    }

    // Verifikasi langsung dari SharedPreferences.
    final hasilVerifikasi =
        _preferensi.getBool(_kunciSudahInstal);

    if (hasilVerifikasi != true) {
      throw Exception(
        'Verifikasi gagal: '
        'sudah_instal tidak bernilai true '
        'setelah penyimpanan.',
      );
    }
  }

  Future<void> tandaiSudahInstal() async {
    final berhasil = await _preferensi.setBool(
      _kunciSudahInstal,
      true,
    );

    if (!berhasil) {
      throw Exception(
        'Gagal menyimpan status sudah_instal.',
      );
    }

    final hasilVerifikasi =
        _preferensi.getBool(_kunciSudahInstal);

    if (hasilVerifikasi != true) {
      throw Exception(
        'Verifikasi gagal: '
        'sudah_instal tidak bernilai true.',
      );
    }
  }
}