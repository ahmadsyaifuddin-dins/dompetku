import 'package:flutter/material.dart';

import '../../komponen/keadaan/keadaan_kosong.dart';

class HalamanBacaGambar extends StatelessWidget {
  const HalamanBacaGambar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Baca dari Gambar')),
      body: SafeArea(
        child: KeadaanKosong(
          ikon: Icons.document_scanner_outlined,
          judul: 'OCR belum tersedia di build ini',
          pesan: 'Fitur membaca struk dari gambar akan hadir di '
              'versi berikutnya. Gunakan formulir Catat untuk '
              'mencatat transaksi secara manual.',
        ),
      ),
    );
  }
}