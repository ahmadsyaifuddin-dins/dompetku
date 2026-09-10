import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositori/repositori_piutang.dart';
import '../../inti/layanan/layanan_saldo.dart';
import '../../inti/utilitas/format_rupiah.dart';
import '../../inti/utilitas/format_tanggal.dart';
import '../../komponen/keadaan/keadaan_kosong.dart';
import '../../komponen/pemuatan/pemuatan_shimmer.dart';
import '../../utama/rute.dart';
import 'piutang_controller.dart';

class HalamanPiutang extends StatelessWidget {
  const HalamanPiutang({super.key});

  @override
  Widget build(BuildContext context) {
    final pengontrol = Get.put(
      PiutangController(
        repositoriPiutang: Get.find<RepositoriPiutang>(),
        layananSaldo: Get.find<LayananSaldo>(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Piutang'),
        actions: [
          IconButton(
            tooltip: 'Tambah Penerima Pinjaman',
            onPressed: () => Get.toNamed(Rute.tambahPiutang),
            icon: const Icon(Icons.person_add_alt_1_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => pengontrol.muatUlang(),
        child: Obx(() {
          if (pengontrol.pemuatan.value) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                KartuSkeletonTransaksi(),
                SizedBox(height: 12),
                KartuSkeletonTransaksi(),
                SizedBox(height: 12),
                KartuSkeletonTransaksi(),
              ],
            );
          }
          if (pengontrol.daftar.isEmpty) {
            return KeadaanKosong(
              ikon: Icons.people_alt_rounded,
              judul: 'Belum ada piutang',
              pesan: 'Catat pinjaman yang kamu berikan untuk mengelola '
                  'piutang berbasis orang.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: pengontrol.daftar.length,
            itemBuilder: (context, indeks) {
              final item = pengontrol.daftar[indeks];
              final lunas = item.sisa <= 0;
              final warnaSisa = lunas
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => pengontrol.bukaDetail(item),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      leading: CircleAvatar(
                        backgroundColor: warnaSisa.withValues(alpha: 0.13),
                        foregroundColor: warnaSisa,
                        child: Text(
                          item.piutang.nama.isEmpty
                              ? '?'
                              : item.piutang.nama.characters.first
                                  .toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      title: Text(
                        item.piutang.nama,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Terakhir diperbarui ${_labelPerbarui(item.piutang.diperbaruiPada)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            lunas ? 'Lunas' : 'Sisa',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                          Text(
                            formatRupiah(item.sisa),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: warnaSisa,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, indent: 62),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  String _labelPerbarui(DateTime tanggal) {
    final kini = DateTime.now();
    final hari = DateTime(tanggal.year, tanggal.month, tanggal.day);
    final hariIni = DateTime(kini.year, kini.month, kini.day);
    final kemarin = hariIni.subtract(const Duration(days: 1));
    if (hari == hariIni) return 'hari ini';
    if (hari == kemarin) return 'kemarin';
    return formatTanggal(tanggal);
  }
}