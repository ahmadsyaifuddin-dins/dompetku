import 'package:flutter/material.dart';

import '../../inti/konstanta/ikon_map.dart';
import '../../inti/tema/warna_tema.dart';
import '../../inti/utilitas/format_rupiah.dart';
import '../../inti/utilitas/hitung_analitik.dart';

/// Daftar batang horizontal distribusi pengeluaran per kategori,
/// dengan ikon, nama, nominal, dan persentase.
class GrafikDistribusiKategori extends StatelessWidget {
  final List<DistribusiKategori> data;

  const GrafikDistribusiKategori({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    if (data.isEmpty) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: tema.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.pie_chart_outline_rounded,
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Belum ada pengeluaran',
              style: tema.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Catat pengeluaran pertamamu untuk melihat\n'
              'ke mana uangmu digunakan.',
              textAlign: TextAlign.center,
              style: tema.textTheme.bodySmall
                  ?.copyWith(color: tema.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
          ],
        ),
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
          if (i < data.length - 1) const SizedBox(height: 14),
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
    final tema = Theme.of(context);
    final warnaDompetku = tema.extension<WarnaDompetku>()!;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: warnaDompetku.pengeluaran.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            ikonUntukKategori(item.ikon),
            size: 17,
            color: warnaDompetku.pengeluaran,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${item.persen.toStringAsFixed(0)}%',
                    style: tema.textTheme.labelMedium
                        ?.copyWith(color: tema.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: lebarPorsi.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: tema.colorScheme.surfaceContainerHighest,
                  color: warnaDompetku.pengeluaran.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          formatRupiah(item.total),
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: tema.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}