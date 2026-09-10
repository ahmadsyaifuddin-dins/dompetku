import 'package:flutter/material.dart';

import '../../inti/tema/warna_tema.dart';
import '../../inti/utilitas/format_rupiah.dart';

enum JenisArus { pemasukan, pengeluaran }

class KartuArus extends StatelessWidget {
  final JenisArus jenis;
  final String label;
  final int nominal;

  const KartuArus({
    super.key,
    required this.jenis,
    required this.label,
    required this.nominal,
  });

  @override
  Widget build(BuildContext context) {
    final warnaDompetku = Theme.of(context).extension<WarnaDompetku>()!;
    final (warna, ikon, tanda) = switch (jenis) {
      JenisArus.pemasukan => (
          warnaDompetku.pemasukan,
          Icons.south_west_rounded,
          '+',
        ),
      JenisArus.pengeluaran => (
          warnaDompetku.pengeluaran,
          Icons.north_east_rounded,
          '-',
        ),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(ikon, size: 18, color: warna),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$tanda${formatRupiah(nominal)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: warna,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}