import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositori/repositori_piutang.dart';
import '../../inti/layanan/layanan_saldo.dart';
import '../../inti/utilitas/format_rupiah.dart';
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
      appBar: AppBar(title: const Text('Piutang')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => Get.toNamed(Rute.tambahPiutang),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah'),
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: pengontrol.daftar.length,
            itemBuilder: (context, indeks) {
              final item = pengontrol.daftar[indeks];
              final lunas = item.sisa <= 0;
              final warnaSisa = lunas
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    onTap: () => pengontrol.bukaDetail(item),
                    leading: CircleAvatar(
                      backgroundColor: warnaSisa.withValues(alpha: 0.14),
                      foregroundColor: warnaSisa,
                      child: Text(
                        item.piutang.nama.isEmpty
                            ? '?'
                            : item.piutang.nama.characters.first
                                .toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    title: Text(
                      item.piutang.nama,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${item.totalPinjaman > 0 ? "Dipinjamkan ${formatRupiah(item.totalPinjaman)}" : "Belum ada pinjaman"}'
                      '${item.totalPembayaran > 0 && item.sisa > 0 ? " • Dibayar ${formatRupiah(item.totalPembayaran)}" : ""}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                            fontWeight: FontWeight.w700,
                            color: warnaSisa,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}