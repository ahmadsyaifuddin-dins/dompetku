import 'package:flutter/material.dart';

import '../../komponen/keadaan/keadaan_kosong.dart';

class HalamanPiutang extends StatelessWidget {
  const HalamanPiutang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Piutang')),
      body: const KeadaanKosong(
        ikon: Icons.people_alt_rounded,
        judul: 'Belum ada piutang',
        pesan:
            'Catat pinjaman yang kamu berikan untuk mengelola piutang '
            'berbasis orang.',
      ),
    );
  }
}