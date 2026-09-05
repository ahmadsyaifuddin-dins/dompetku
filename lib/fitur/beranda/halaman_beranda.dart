import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../inti/utilitas/format_rupiah.dart';
import '../../komponen/kartu/kartu_saldo.dart';
import '../../komponen/keadaan/keadaan_kosong.dart';
import '../../komponen/pemuatan/pemuatan_shimmer.dart';
import 'beranda_controller.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    final pengontrol = Get.isRegistered<BerandaController>()
        ? Get.find<BerandaController>()
        : Get.put(BerandaController(Get.find()));
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('DompetKu')),
      body: RefreshIndicator(
        onRefresh: () async => pengontrol.muatUlang(),
        child: Obx(() {
          if (pengontrol.loading.value) {
            return _TampilanPemuatan(tema: tema);
          }
          if (pengontrol.galat.value) {
            return KeadaanKosong(
              ikon: Icons.wifi_off_rounded,
              judul: 'Terjadi kesalahan',
              pesan: 'Gagal mengambil data. Periksa kembali lalu coba lagi.',
              aksi: TextButton.icon(
                onPressed: pengontrol.muatUlang,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba lagi'),
              ),
            );
          }
          if (pengontrol.akun.isEmpty) {
            return KeadaanKosong(
              ikon: Icons.receipt_long_rounded,
              judul: 'Belum ada transaksi',
              pesan:
                  'Mulai catat pemasukan atau pengeluaran untuk melihat '
                  'ringkasan keuanganmu.',
            );
          }
          return _TampilanData(pengontrol: pengontrol, tema: tema);
        }),
      ),
    );
  }
}

class _TampilanPemuatan extends StatelessWidget {
  final ThemeData tema;
  const _TampilanPemuatan({required this.tema});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PemuatanShimmer(
          anak: BlokSkeleton(tinggi: 120, radius: 20),
        ),
        const SizedBox(height: 24),
        BlokSkeletonTeks(),
        const SizedBox(height: 16),
        ...List.generate(3, (_) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: KartuSkeletonTransaksi(),
            )),
      ],
    );
  }
}

class BlokSkeletonTeks extends StatelessWidget {
  const BlokSkeletonTeks({super.key});

  @override
  Widget build(BuildContext context) {
    return const PemuatanShimmer(
      anak: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlokSkeleton(tinggi: 16, lebar: 90),
          SizedBox(height: 8),
          BlokSkeleton(tinggi: 14, lebar: 160),
        ],
      ),
    );
  }
}

class _TampilanData extends StatelessWidget {
  final BerandaController pengontrol;
  final ThemeData tema;

  const _TampilanData({required this.pengontrol, required this.tema});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        KartuSaldo(
          judul: 'Total Saldo',
          nominal: formatRupiah(pengontrol.totalSaldo),
          ikon: Icons.account_balance_wallet_rounded,
        ),
        const SizedBox(height: 24),
        Text(
          'Akun Dana',
          style: tema.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...pengontrol.akun.map(_kartuAkun),
      ],
    );
  }

  Widget _kartuAkun(AkunDanaData akun) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: tema.colorScheme.primaryContainer,
            foregroundColor: tema.colorScheme.onPrimaryContainer,
            child: Icon(_ikonAkun(akun.jenis)),
          ),
          title: Text(akun.nama),
          subtitle: Text(_labelJenis(akun.jenis)),
          trailing: Text(
            formatRupiah(akun.saldoAwal),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  IconData _ikonAkun(JenisAkun jenis) {
    return switch (jenis) {
      JenisAkun.cash => Icons.payments_rounded,
      JenisAkun.bank => Icons.account_balance_rounded,
      JenisAkun.ewallet => Icons.smartphone_rounded,
    };
  }

  String _labelJenis(JenisAkun jenis) {
    return switch (jenis) {
      JenisAkun.cash => 'Tunai',
      JenisAkun.bank => 'Bank',
      JenisAkun.ewallet => 'E-Wallet',
    };
  }
}