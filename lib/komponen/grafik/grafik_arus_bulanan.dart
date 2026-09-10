import 'package:flutter/material.dart';

import '../../inti/tema/warna_tema.dart';
import '../../inti/utilitas/format_rupiah.dart';
import '../../inti/utilitas/hitung_analitik.dart';

/// Grafik batang berpasangan (pemasukan vs pengeluaran) — minimal, fokus
/// pada insight, bukan meniru widget chart demo.
class GrafikArusBulanan extends StatelessWidget {
  final List<DataArusBulanan> data;
  final double tinggiMaks;

  const GrafikArusBulanan({
    super.key,
    required this.data,
    this.tinggiMaks = 120,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warnaDompetku = tema.extension<WarnaDompetku>()!;
    final terbesar = data.fold<int>(
      0,
      (maks, b) => b.pemasukan > maks
          ? b.pemasukan
          : (b.pengeluaran > maks ? b.pengeluaran : maks),
    );

    if (terbesar <= 0) {
      return SizedBox(
        height: tinggiMaks,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.query_stats_rounded,
                size: 32, color: tema.colorScheme.onSurfaceVariant),
            const SizedBox(height: 10),
            Text(
              'Belum ada data arus kas',
              style: tema.textTheme.bodyMedium
                  ?.copyWith(color: tema.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _PetunjukBagan(
              warna: warnaDompetku.pemasukan,
              label: 'Pemasukan',
            ),
            const SizedBox(width: 16),
            _PetunjukBagan(
              warna: warnaDompetku.pengeluaran,
              label: 'Pengeluaran',
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: tinggiMaks + 26,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final bulan in data)
                Expanded(
                  child: _KolomBulan(
                    data: bulan,
                    tinggiMaks: tinggiMaks,
                    terbesar: terbesar,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PetunjukBagan extends StatelessWidget {
  final Color warna;
  final String label;

  const _PetunjukBagan({required this.warna, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _KolomBulan extends StatelessWidget {
  final DataArusBulanan data;
  final double tinggiMaks;
  final int terbesar;

  const _KolomBulan({
    required this.data,
    required this.tinggiMaks,
    required this.terbesar,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warnaDompetku = tema.extension<WarnaDompetku>()!;

    double tinggi(int nilai) {
      if (nilai <= 0) return 4;
      return (nilai / terbesar) * tinggiMaks;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: tinggiMaks,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tooltip(
                message: 'Pemasukan ${formatRupiah(data.pemasukan)}',
                child: Container(
                  width: 12,
                  height: tinggi(data.pemasukan),
                  decoration: BoxDecoration(
                    color: warnaDompetku.pemasukan.withValues(alpha: 0.85),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Tooltip(
                message: 'Pengeluaran ${formatRupiah(data.pengeluaran)}',
                child: Container(
                  width: 12,
                  height: tinggi(data.pengeluaran),
                  decoration: BoxDecoration(
                    color: warnaDompetku.pengeluaran.withValues(alpha: 0.85),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.label,
          style: tema.textTheme.labelSmall
              ?.copyWith(color: warnaDompetku.netral),
        ),
      ],
    );
  }
}