import 'package:flutter/material.dart';

import '../../inti/tema/warna_tema.dart';
import '../../inti/utilitas/format_rupiah.dart';
import '../../inti/utilitas/hitung_analitik.dart';

/// Daftar batang horizontal distribusi pengeluaran per kategori.
class GrafikDistribusiKategori extends StatelessWidget {
  final List<DistribusiKategori> data;

  const GrafikDistribusiKategori({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    if (data.isEmpty) {
      return Text(
        'Belum ada pengeluaran periode ini.',
        style: TextStyle(color: warna.onSurfaceVariant),
      );
    }

    final terbesar = data.first.total;
    return Column(
      children: [
        for (var i = 0; i < data.length; i++) ...[
          _BarisKategori(
            item: data[i],
            lebarPorsi: terbesar <= 0 ? 0 : data[i].total / terbesar,
          ),
          if (i < data.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _BarisKategori extends StatelessWidget {
  final DistribusiKategori item;
  final double lebarPorsi;

  const _BarisKategori({required this.item, required this.lebarPorsi});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final warnaDompetku = Theme.of(context).extension<WarnaDompetku>()!;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            item.nama,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: lebarPorsi.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: warna.surfaceContainerHighest,
              color: warnaDompetku.pengeluaran.withValues(alpha: 0.75),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 64,
          child: Text(
            formatRupiah(item.total),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: warna.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}