import 'package:flutter/foundation.dart';

/// Log debug dalam memori yang bisa dipantau langsung di layar.
///
/// Bersifat global agar tetap hidup meski halaman perlu di-navigasi ulang,
/// misalnya saat menelusuri jalur notifikasi WhatsApp setelah tombol
/// "Mulai Menggunakan" ditekan. Dipakai bersama [PanelDebug].
class DebugLog {
  DebugLog._();

  static final DebugLog saya = DebugLog._();

  static const int _batasEntri = 500;

  final List<String> _entri = <String>[];
  final _notifier = ValueNotifier<List<String>>(const <String>[]);

  /// Aliran entri log (dipakai widget untuk membangun ulang layar).
  ValueListenable<List<String>> get aliran => _notifier;

  /// Salinan entri terkini untuk disalin/diuji.
  List<String> get entri => List.unmodifiable(_notifier.value);

  int get jumlahGalat =>
      _notifier.value.where((baris) => baris.contains('✗')).length;

  void tulis(String pesan) {
    final stempel = _stempelJam();
    _entri.add('[$stempel] $pesan');
    if (_entri.length > _batasEntri) {
      _entri.removeRange(0, _entri.length - _batasEntri);
    }
    _notifier.value = List.unmodifiable(_entri);
  }

  void bersihkan() {
    _entri.clear();
    _notifier.value = const <String>[];
  }

  String _stempelJam() {
    final kini = DateTime.now();
    String dua(int angka) => angka.toString().padLeft(2, '0');
    return '${dua(kini.hour)}:${dua(kini.minute)}:${dua(kini.second)}';
  }
}