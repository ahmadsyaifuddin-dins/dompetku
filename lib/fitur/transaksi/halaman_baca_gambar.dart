import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../komponen/snackbar/snackbar_dompetku.dart';
import '../../komponen/tombol/tombol_utama.dart';
import '../../utama/rute.dart';
import 'draft_transaksi_ocr.dart';

/// Pratinjau alur "Baca dari Gambar".
///
/// Mesin OCR belum dikunci (PRD 20); layar ini memungkinkan alur review
/// dicoba dengan teks yang ditempel, sehingga [ekstrakDraftDariTeks] dan
/// [HalamanReviewOCR] dapat dipakai saat OCR sungguhan tersedia nanti.
class HalamanBacaGambar extends StatefulWidget {
  const HalamanBacaGambar({super.key});

  @override
  State<HalamanBacaGambar> createState() => _HalamanBacaGambarState();
}

class _HalamanBacaGambarState extends State<HalamanBacaGambar> {
  final _teksController = TextEditingController();

  @override
  void dispose() {
    _teksController.dispose();
    super.dispose();
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: warna.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Pratinjau alur OCR',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fitur unggah gambar belum aktif di build ini. '
                      'Tempel teks hasil bacaan untuk mencoba alur '
                      'draft → periksa → koreksi → simpan.',
                      style: TextStyle(color: warna.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
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
              onDitekan: () => _bacaDanTinjau(context),
            ),
          ],
        ),
      ),
    );
  }

  void _bacaDanTinjau(BuildContext context) {
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
}