import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Pembaca teks (OCR) dari berkas gambar.
///
/// Menggunakan ML Kit Text Recognition di Android dan iOS secara offline.
/// Web belum didukung mesin ini; [bacaTeks] mengembalikan null di sana.
class LayananOcr {
  /// Mengembalikan teks mentah yang terbaca, atau null bila gagal /
  /// platform tidak didukung / tidak ada teks.
  Future<String?> bacaTeks(String pathGambar) async {
    if (kIsWeb) return null;

    final pengenal = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final citra = InputImage.fromFilePath(pathGambar);
      final hasil = await pengenal.processImage(citra);
      final teks = hasil.text.trim();
      return teks.isEmpty ? null : teks;
    } catch (_) {
      return null;
    } finally {
      await pengenal.close();
    }
  }
}