import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../inti/konstanta/ikon_map.dart';
import '../../inti/layanan/layanan_saldo.dart';
import '../../inti/utilitas/format_rupiah.dart';
import '../../inti/utilitas/hitung_analitik.dart';
import '../../komponen/grafik/grafik_arus_bulanan.dart';
import '../../komponen/grafik/grafik_distribusi_kategori.dart';
import '../../komponen/kartu/kartu_arus.dart';
import '../../komponen/kartu/kartu_entri_histori.dart';
import '../../komponen/kartu/kartu_saldo.dart';
import '../../komponen/keadaan/keadaan_kosong.dart';
import '../../komponen/pemuatan/pemuatan_shimmer.dart';
import '../transaksi/papan_aksi_entri.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    final layananSaldo = Get.find<LayananSaldo>();
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('DompetKu')),
      body: RefreshIndicator(
        onRefresh: () async => layananSaldo.muatUlang(),
        child: Obx(() {
          if (layananSaldo.pemuatan.value) {
            return const _TampilanPemuatan();
          }
          if (layananSaldo.akun.isEmpty) {
            return KeadaanKosong(
              ikon: Icons.account_balance_wallet_rounded,
              judul: 'Belum ada akun dana',
              pesan:
                  'Tambahkan akun dana untuk mulai mencatat transaksimu.',
            );
          }
          final histori = layananSaldo.histori;
          final sekarang = DateTime.now();
          final arusBulanIni = ringkasArusBulan(
            transaksi: layananSaldo.transaksi,
            bulan: sekarang,
          );
          final arusBulanan = dataArusBulanan(
            transaksi: layananSaldo.transaksi,
            sampai: sekarang,
          );
          final distribusi = hitungDistribusiPengeluaran(
            transaksi: layananSaldo.transaksi,
            petaKategori: layananSaldo.petaKategori,
            awal: DateTime(sekarang.year, sekarang.month, 1),
            akhir: DateTime(sekarang.year, sekarang.month + 1, 0),
          );
          final punyaTransaksi = layananSaldo.transaksi.isNotEmpty
              || layananSaldo.transfer.isNotEmpty;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              KartuSaldo(
                judul: 'Total Saldo',
                nominal: formatRupiah(layananSaldo.totalSaldo),
                ikon: Icons.account_balance_wallet_rounded,
              ),
              const SizedBox(height: 24),
              Text(
                'Arus Uang Bulan Ini',
                style: tema.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: KartuArus(
                      jenis: JenisArus.pemasukan,
                      label: 'Pemasukan',
                      nominal: arusBulanIni.totalPemasukan,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KartuArus(
                      jenis: JenisArus.pengeluaran,
                      label: 'Pengeluaran',
                      nominal: arusBulanIni.totalPengeluaran,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Pemasukan vs Pengeluaran',
                style: tema.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrafikArusBulanan(data: arusBulanan),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Kategori Pengeluaran',
                style: tema.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GrafikDistribusiKategori(data: distribusi),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Akun Dana',
                style: tema.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...layananSaldo.akun.map(
                (akun) => _kartuAkun(tema, layananSaldo, akun),
              ),
              const SizedBox(height: 24),
              Text(
                'Aktivitas Terbaru',
                style: tema.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              if (!punyaTransaksi)
                KeadaanKosong(
                  ikon: Icons.receipt_long_rounded,
                  judul: 'Belum ada transaksi',
                  pesan:
                      'Mulai catat pemasukan atau pengeluaran untuk melihat '
                      'ringkasan keuanganmu.',
                )
              else
                ...histori.take(5).map(
                      (entri) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: KartuEntriHistori(
                          entri: entri,
                          onTap: () => bukaAksiEntri(context, entri),
                        ),
                      ),
                    ),
            ],
          );
        }),
      ),
    );
  }

  Widget _kartuAkun(
    ThemeData tema,
    LayananSaldo layanan,
    AkunDanaData akun,
  ) {
    final saldo = layanan.saldoPerAkun[akun.id] ?? akun.saldoAwal;
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
            formatRupiah(saldo),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  IconData _ikonAkun(JenisAkun jenis) {
    return ikonUntukAkunDana(jenis.nama);
  }

  String _labelJenis(JenisAkun jenis) {
    return switch (jenis) {
      JenisAkun.cash => 'Tunai',
      JenisAkun.bank => 'Bank',
      JenisAkun.ewallet => 'E-Wallet',
    };
  }
}

class _TampilanPemuatan extends StatelessWidget {
  const _TampilanPemuatan();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PemuatanShimmer(
          anak: BlokSkeleton(tinggi: 120, radius: 20),
        ),
        const SizedBox(height: 24),
        const BlokSkeletonTeks(),
        const SizedBox(height: 16),
        ...List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: KartuSkeletonTransaksi(),
          ),
        ),
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