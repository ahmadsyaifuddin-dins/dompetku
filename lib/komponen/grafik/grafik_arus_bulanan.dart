import 'package:flutter/material.dart';

import '../../inti/tema/warna_tema.dart';
import '../../inti/utilitas/format_rupiah.dart';
import '../../inti/utilitas/hitung_analitik.dart';

/// Grafik batang berpasangan (pemasukan vs pengeluaran) per bulan.
class GrafikArusBulanan extends StatelessWidget {
  final List<DataArusBulanan> data;
  final double tinggiMaks;

  const GrafikArusBulanan({
    super.key,
    required this.data,
    this.tinggiMaks = 140,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final terbesar = data.fold<int>(
      0,
      (maks, b) => b.pemasukan > maks
          ? b.pemasukan
          : (b.pengeluaran > maks ? b.pengeluaran : maks),
    );

    if (terbesar <= 0) {
      return SizedBox(
        height: tinggiMaks,
        child: Center(
          child: Text(
            'Belum ada data arus kas',
            style: TextStyle(color: warna.onSurfaceVariant),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: tinggiMaks + 28,
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
    final warna = Theme.of(context).colorScheme;
    final warnaDompetku = Theme.of(context).extension<WarnaDompetku>()!;

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
                    color: warnaDompetku.pemasukan,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Tooltip(
                message: 'Pengeluaran ${formatRupiah(data.pengeluaran)}',
                child: Container(
                  width: 12,
                  height: tinggi(data.pengeluaran),
                  decoration: BoxDecoration(
                    color: warnaDompetku.pengeluaran,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          data.label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: warna.onSurfaceVariant),
        ),
      ],
    );
  }
}