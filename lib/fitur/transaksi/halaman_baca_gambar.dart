import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/routes.dart';
import '../../core/services/layanan_ocr.dart';
import '../../komponen/snackbar/snackbar_dompetku.dart';
import '../../komponen/tombol/tombol_utama.dart';
import 'draft_transaksi_ocr.dart';

/// Alur "Baca dari Gambar": foto/unggah struk atau notifikasi bank/e-wallet,
/// teks dibaca secara otomatis (ML Kit di Android & iOS), lalu diarahkan ke
/// layar tinjauan untuk dikoreksi sebelum disimpan (PRD 15).
class HalamanBacaGambar extends StatefulWidget {
  const HalamanBacaGambar({super.key});

  @override
  State<HalamanBacaGambar> createState() => _HalamanBacaGambarState();
}

class _HalamanBacaGambarState extends State<HalamanBacaGambar> {
  final _pemilih = ImagePicker();
  final _teksController = TextEditingController();
  XFile? _gambar;
  bool _memproses = false;

  @override
  void dispose() {
    _teksController.dispose();
    super.dispose();
  }

  Future<void> _ambilGambar(ImageSource sumber) async {
    if (kIsWeb) {
      tampilkanSnackbarDompetku(
        jenis: JenisSnackbar.informasi,
        judul: 'OCR aktif di perangkat',
        pesan: 'Baca dari gambar berjalan di aplikasi Android & iOS. '
            'Di browser, tempel teks hasil scan pada kolom di bawah.',
      );
      return;
    }

    try {
      final berkas = await _pemilih.pickImage(
        source: sumber,
        maxWidth: 2400,
        imageQuality: 92,
      );
      if (berkas == null || !mounted) return;
      setState(() => _gambar = berkas);
    } catch (_) {
      if (!mounted) return;
      tampilkanSnackbarDompetku(
        jenis: JenisSnackbar.galat,
        judul: 'Gagal membuka gambar',
        pesan: 'Tidak dapat mengakses kamera atau galeri. Coba lagi.',
      );
      return;
    }

    await _jalankanOcr();
  }

  Future<void> _jalankanOcr() async {
    final gambar = _gambar;
    if (gambar == null) return;
    setState(() => _memproses = true);
    final teks = await LayananOcr().bacaTeks(gambar.path);
    if (!mounted) return;
    setState(() => _memproses = false);

    if (teks == null) {
      tampilkanSnackbarDompetku(
        jenis: JenisSnackbar.galat,
        judul: 'Tidak terbaca',
        pesan: 'Tidak ada teks yang terbaca dari gambar. '
            'Gunakan foto yang lebih jelas atau tempel teks manual di bawah.',
      );
      return;
    }

    final draft = buatDraftTeksMentah(teks);
    Get.toNamed(Rute.reviewOCR, arguments: draft);
  }

  void _jalankanDariTeks() {
    final teks = _teksController.text.trim();
    if (teks.isEmpty) {
      tampilkanSnackbarDompetku(
        jenis: JenisSnackbar.peringatan,
        judul: 'Teks kosong',
        pesan: 'Tempel teks hasil OCR atau ketuk "Isi dengan contoh".',
      );
      return;
    }

    final draft = ekstrakDraftDariTeks(teks);
    if (draft == null) {
      tampilkanSnackbarDompetku(
        jenis: JenisSnackbar.galat,
        judul: 'Tidak terbaca',
        pesan:
            'Tidak menemukan nominal (misal "Nominal: Rp75.000"). '
            'Periksa format teks yang ditempel.',
      );
      return;
    }

    Get.toNamed(Rute.reviewOCR, arguments: draft);
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Baca dari Gambar')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _kartuInfo(context),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _memproses ? null : () => _ambilGambar(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Pilih Gambar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _memproses ? null : () => _ambilGambar(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Ambil Foto'),
                  ),
                ),
              ],
            ),
            if (_gambar != null) ...[
              const SizedBox(height: 16),
              _pratinjauGambar(context, warna),
            ],
            if (_memproses) ...[
              const SizedBox(height: 16),
              const _KartuProses(),
            ],
            const SizedBox(height: 24),
            const _Pemisah('atau tempel teks manual'),
            const SizedBox(height: 16),
            TextField(
              controller: _teksController,
              maxLines: 7,
              decoration: InputDecoration(
                labelText: 'Teks hasil OCR',
                hintText: contohTeksOCR,
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.document_scanner_outlined),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  _teksController.text = contohTeksOCR;
                  setState(() {});
                },
                icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                label: const Text('Isi dengan contoh'),
              ),
            ),
            const SizedBox(height: 8),
            TombolUtama(
              label: 'Baca & Tinjau',
              ikon: Icons.rate_review_rounded,
              onDitekan: _jalankanDariTeks,
            ),
          ],
        ),
      ),
    );
  }

  Widget _kartuInfo(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.document_scanner_rounded, color: warna.primary),
                const SizedBox(width: 8),
                Text(
                  'Baca transaksi dari foto',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih foto struk atau notifikasi bank/e-wallet. Teks dibaca '
              'di perangkat, lalu kamu tinjau dan koreksi sebelum disimpan.',
              style: TextStyle(color: warna.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              'OCR otomatis tersedia di Android & iOS.',
              style: TextStyle(
                color: warna.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pratinjauGambar(BuildContext context, ColorScheme warna) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 220,
        width: double.infinity,
        color: warna.surfaceContainerHighest,
        child: FutureBuilder<Uint8List>(
          future: _gambar!.readAsBytes(),
          builder: (konteks, keadaan) {
            if (!keadaan.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Image.memory(keadaan.data!, fit: BoxFit.cover);
          },
        ),
      ),
    );
  }
}

class _KartuProses extends StatelessWidget {
  const _KartuProses();

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: warna.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Membaca teks dari gambar...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pemisah extends StatelessWidget {
  final String teks;

  const _Pemisah(this.teks);

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(color: warna.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            teks,
            style: TextStyle(
              color: warna.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(child: Divider(color: warna.outlineVariant)),
      ],
    );
  }
}