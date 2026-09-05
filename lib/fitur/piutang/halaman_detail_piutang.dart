import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../data/repositori/repositori_piutang.dart';
import '../../inti/layanan/layanan_saldo.dart';
import '../../inti/utilitas/format_rupiah.dart';
import '../../inti/utilitas/format_tanggal.dart';
import '../../komponen/keadaan/keadaan_kosong.dart';
import 'detail_piutang_controller.dart';
import 'lembar_aksi_piutang.dart';

class HalamanDetailPiutang extends StatelessWidget {
  const HalamanDetailPiutang({super.key});

  @override
  Widget build(BuildContext context) {
    final piutang = Get.arguments as PiutangData;
    final pengontrol = Get.put(
      DetailPiutangController(
        repositoriPiutang: Get.find<RepositoriPiutang>(),
        piutang: piutang,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Piutang')),
      body: SafeArea(
        child: Obx(() {
          final sisa = pengontrol.sisa;
          final lunas = sisa <= 0;
          return Column(
            children: [
              _kepalaPiutang(context, piutang, sisa, lunas),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => bukaLembarAksiPiutang(
                          context,
                          pengontrol,
                          jenis: JenisRiwayat.pinjaman,
                          piutang: piutang,
                        ),
                        icon: const Icon(Icons.south_east_rounded),
                        label: const Text('Pinjaman'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: lunas
                            ? null
                            : () => bukaLembarAksiPiutang(
                                  context,
                                  pengontrol,
                                  jenis: JenisRiwayat.pembayaran,
                                  piutang: piutang,
                                ),
                        icon: const Icon(Icons.north_west_rounded),
                        label: const Text('Bayar'),
                      ),
                    ),
                  ],
                ),
              ),
              if (!lunas)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => bukaLembarAksiPiutang(
                        context,
                        pengontrol,
                        jenis: JenisRiwayat.pembayaran,
                        piutang: piutang,
                        praisiNominal: sisa,
                      ),
                      icon: const Icon(Icons.verified_rounded),
                      label: const Text('Lunasi'),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: pengontrol.riwayat.isEmpty
                    ? KeadaanKosong(
                        ikon: Icons.history_rounded,
                        judul: 'Belum ada kejadian',
                        pesan: 'Catat pinjaman pertama untuk mulai '
                            'melacak piutang ${piutang.nama}.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: pengontrol.riwayat.length,
                        itemBuilder: (context, indeks) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _KartuKejadian(
                            riwayat: pengontrol.riwayat[indeks],
                          ),
                        ),
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _kepalaPiutang(
    BuildContext context,
    PiutangData piutang,
    int sisa,
    bool lunas,
  ) {
    final tema = Theme.of(context);
    final sisaWarna =
        lunas ? tema.colorScheme.primary : tema.colorScheme.error;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: sisaWarna.withValues(alpha: 0.14),
            foregroundColor: sisaWarna,
            child: Text(
              piutang.nama.isEmpty
                  ? '?'
                  : piutang.nama.characters.first.toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  piutang.nama,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (piutang.catatan != null &&
                    piutang.catatan!.isNotEmpty)
                  Text(
                    piutang.catatan!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                lunas ? 'Lunas' : 'Sisa',
                style: TextStyle(
                  fontSize: 12,
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                formatRupiah(sisa),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: sisaWarna,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KartuKejadian extends StatelessWidget {
  final RiwayatPiutangData riwayat;

  const _KartuKejadian({required this.riwayat});

  @override
  Widget build(BuildContext context) {
    final layanan = Get.find<LayananSaldo>();
    final akun = layanan.petaAkun[riwayat.akunDanaId];

    final (ikon, warna, label, tanda) = switch (riwayat.jenis) {
      JenisRiwayat.pinjaman => (
          Icons.south_east_rounded,
          Theme.of(context).colorScheme.error,
          'Pinjaman',
          '-',
        ),
      JenisRiwayat.tambahan => (
          Icons.add_rounded,
          Theme.of(context).colorScheme.error,
          'Tambahan',
          '-',
        ),
      JenisRiwayat.pembayaran => (
          Icons.north_west_rounded,
          Theme.of(context).colorScheme.primary,
          'Pembayaran',
          '+',
        ),
    };

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: warna.withValues(alpha: 0.14),
          foregroundColor: warna,
          child: Icon(ikon, size: 20),
        ),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${akun?.nama ?? 'Akun terhapus'} • ${formatTanggal(riwayat.tanggal)}',
        ),
        trailing: Text(
          '$tanda${formatRupiah(riwayat.nominal)}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: warna,
          ),
        ),
      ),
    );
  }
}