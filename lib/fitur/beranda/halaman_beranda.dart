import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../core/constants/ikon_map.dart';
import '../../core/services/layanan_saldo.dart';
import '../../core/utils/format_rupiah.dart';
import '../../core/utils/hitung_analitik.dart';
import '../../komponen/grafik/grafik_arus_bulanan.dart';
import '../../komponen/grafik/grafik_distribusi_kategori.dart';
import '../../komponen/kartu/kartu_arus.dart';
import '../../komponen/kartu/kartu_entri_histori.dart';
import '../../komponen/kartu/kartu_saldo.dart';
import '../../komponen/keadaan/keadaan_kosong.dart';
import '../../komponen/pemuatan/pemuatan_shimmer.dart';
import '../../app/main_controller.dart';
import '../transaksi/papan_aksi_entri.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    final layananSaldo = Get.find<LayananSaldo>();
    final tema = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _KepalaBeranda(),
                const SizedBox(height: 4),
                KartuSaldo(
                  judul: 'Total Saldo',
                  nominal: formatRupiah(layananSaldo.totalSaldo),
                  selisih: arusBulanIni.selisih,
                ),
                const SizedBox(height: 24),
                const _JudulBagian('Arus Bulan Ini'),
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
                const _JudulBagian('Akun Dana'),
                _DaftarAkunHorisontal(
                  akun: layananSaldo.akun,
                  saldoPerAkun: layananSaldo.saldoPerAkun,
                ),
                const SizedBox(height: 24),
                const _JudulBagian('Arus Keuangan'),
                _PanelArus(
                  grafik: GrafikArusBulanan(data: arusBulanan),
                ),
                const SizedBox(height: 20),
                const _JudulBagian('Pengeluaran per Kategori'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: tema.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: tema.colorScheme.outlineVariant),
                  ),
                  child: GrafikDistribusiKategori(data: distribusi),
                ),
                const SizedBox(height: 24),
                const _JudulBagian('Aktivitas Terbaru'),
                if (!punyaTransaksi)
                  KeadaanKosong(
                    ikon: Icons.receipt_long_rounded,
                    judul: 'Belum ada transaksi',
                    pesan:
                        'Mulai catat pemasukan atau pengeluaran untuk '
                        'melihat ringkasan keuanganmu.',
                  )
                else
                  ...List.generate(
                    histori.take(5).length,
                    (indeks) {
                      final batasAkhir = indeks == histori.take(5).length - 1;
                      final entri = histori[indeks];
                      return Column(
                        children: [
                          KartuEntriHistori(
                            entri: entri,
                            onTap: () => bukaAksiEntri(context, entri),
                          ),
                          if (!batasAkhir) const Divider(height: 1),
                        ],
                      );
                    },
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _KepalaBeranda extends StatelessWidget {
  const _KepalaBeranda();

  String _sapa(TimeOfDay kini) {
    if (kini.hour < 11) return 'Selamat pagi';
    if (kini.hour < 15) return 'Selamat siang';
    if (kini.hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final waktu = TimeOfDay.now();
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 2, top: 6, bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _sapa(waktu),
                      style: tema.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 8),
                    const _IkonSapa(),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Ini ringkasan keuanganmu hari ini.',
                  style: tema.textTheme.bodySmall
                      ?.copyWith(color: tema.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Pengaturan',
            onPressed: () => Get.find<KontrolInduk>().ubahIndeks(3),
            icon: const Icon(Icons.settings_outlined),
            color: tema.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _IkonSapa extends StatefulWidget {
  const _IkonSapa();

  @override
  State<_IkonSapa> createState() => _KeadaanIkonSapa();
}

class _KeadaanIkonSapa extends State<_IkonSapa>
    with SingleTickerProviderStateMixin {
  static const Duration _durasiLambai = Duration(milliseconds: 1100);
  static const Duration _jeda = Duration(seconds: 3);

  late final AnimationController _animasi;
  late final Animation<double> _getar;
  late final Timer _pemicu;

  @override
  void initState() {
    super.initState();
    _animasi = AnimationController(vsync: this, duration: _durasiLambai);
    _getar = Tween<double>(begin: -0.06, end: 0.06).animate(
      CurvedAnimation(parent: _animasi, curve: Curves.easeInOut),
    );
    _mulaiLambai();
    _pemicu = Timer.periodic(_jeda, (_) => _mulaiLambai());
  }

  void _mulaiLambai() {
    _animasi.repeat(reverse: true, count: 3);
  }

  @override
  void dispose() {
    _pemicu.cancel();
    _animasi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _getar,
      child: Icon(
        Icons.waving_hand_rounded,
        size: 26,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _JudulBagian extends StatelessWidget {
  final String teks;

  const _JudulBagian(this.teks);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        teks,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _PanelArus extends StatelessWidget {
  final Widget grafik;

  const _PanelArus({required this.grafik});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: warna.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: warna.outlineVariant),
      ),
      child: grafik,
    );
  }
}

class _DaftarAkunHorisontal extends StatelessWidget {
  final List<AkunDanaData> akun;
  final Map<String, int> saldoPerAkun;

  const _DaftarAkunHorisontal({
    required this.akun,
    required this.saldoPerAkun,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: akun.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, indeks) {
          final a = akun[indeks];
          final saldo = saldoPerAkun[a.id] ?? a.saldoAwal;
          return _KartuAkunRingkas(
            nama: a.nama,
            saldo: formatRupiah(saldo),
            ikon: ikonUntukAkunDana(a.jenis.nama),
          );
        },
      ),
    );
  }
}

class _KartuAkunRingkas extends StatelessWidget {
  final String nama;
  final String saldo;
  final IconData ikon;

  const _KartuAkunRingkas({
    required this.nama,
    required this.saldo,
    required this.ikon,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tema.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tema.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(ikon,
              size: 18, color: tema.colorScheme.onSurfaceVariant),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tema.textTheme.bodySmall
                    ?.copyWith(color: tema.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  saldo,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TampilanPemuatan extends StatelessWidget {
  const _TampilanPemuatan();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: const [
        PemuatanShimmer(anak: BlokSkeleton(tinggi: 18, lebar: 160)),
        SizedBox(height: 14),
        PemuatanShimmer(anak: BlokSkeleton(tinggi: 150, radius: 24)),
        SizedBox(height: 24),
        PemuatanShimmer(anak: BlokSkeleton(tinggi: 16, lebar: 110)),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PemuatanShimmer(anak: BlokSkeleton(tinggi: 84)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: PemuatanShimmer(anak: BlokSkeleton(tinggi: 84)),
            ),
          ],
        ),
        SizedBox(height: 24),
        PemuatanShimmer(
          anak: Row(
            children: [
              BlokSkeleton(tinggi: 92, lebar: 150),
              SizedBox(width: 12),
              BlokSkeleton(tinggi: 92, lebar: 150),
            ],
          ),
        ),
        SizedBox(height: 24),
        PemuatanShimmer(anak: BlokSkeleton(tinggi: 170)),
        SizedBox(height: 24),
        KartuSkeletonTransaksi(),
        KartuSkeletonTransaksi(),
        KartuSkeletonTransaksi(),
      ],
    );
  }
}