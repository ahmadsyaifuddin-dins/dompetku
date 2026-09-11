import 'package:flutter/material.dart';

import '../../core/theme/warna_tema.dart';
import '../../core/utils/format_rupiah.dart';

enum JenisArus { pemasukan, pengeluaran }

/// Ringkasan arus ringkas: tidak berat, tanpa kartu besar.
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
          Icons.arrow_downward_rounded,
          '+',
        ),
      JenisArus.pengeluaran => (
          warnaDompetku.pengeluaran,
          Icons.arrow_upward_rounded,
          '-',
        ),
    };
    final tema = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tema.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tema.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ikon, size: 15, color: warna),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tema.textTheme.bodySmall
                      ?.copyWith(color: tema.colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$tanda${formatRupiah(nominal)}',
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: warna,
            ),
          ),
        ],
      ),
    );
  }
}