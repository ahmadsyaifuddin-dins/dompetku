import 'package:flutter/material.dart';

import '../../komponen/keadaan/keadaan_kosong.dart';

class HalamanTransaksi extends StatelessWidget {
  const HalamanTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi')),
      body: const KeadaanKosong(
        ikon: Icons.receipt_long_rounded,
        judul: 'Belum ada transaksi',
        pesan: 'Mulai catat pemasukan atau pengeluaran untuk '
            'melihat riwayat transaksimu.',
      ),
    );
  }
}