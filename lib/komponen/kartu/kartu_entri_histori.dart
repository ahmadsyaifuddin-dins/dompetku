import 'package:flutter/material.dart';

import '../../data/model/ringkasan_entri.dart';
import '../../inti/tema/warna_tema.dart';
import '../../inti/utilitas/format_rupiah.dart';

/// Baris aktivitas/transaksi ringkas — bukan kartu, divisualkan seperti
/// timeline agar daftar tidak terasa seperti tabel.
class KartuEntriHistori extends StatelessWidget {
  final EntriHistori entri;
  final VoidCallback? onTap;

  const KartuEntriHistori({
    super.key,
    required this.entri,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warnaDompetku = tema.extension<WarnaDompetku>()!;

    final (ikon, warnaIkon) = switch (entri.jenis) {
      JenisEntri.pemasukan => (
          Icons.south_west_rounded,
          warnaDompetku.pemasukan,
        ),
      JenisEntri.pengeluaran => (
          Icons.north_east_rounded,
          warnaDompetku.pengeluaran,
        ),
      JenisEntri.transfer => (
          Icons.swap_horiz_rounded,
          warnaDompetku.aksen,
        ),
    };

    final (tanda, warnaNominal) = switch (entri.jenis) {
      JenisEntri.pemasukan => ('+', warnaDompetku.pemasukan),
      JenisEntri.pengeluaran => ('-', warnaDompetku.pengeluaran),
      JenisEntri.transfer => ('', warnaDompetku.aksen),
    };

    final subtitle = switch (entri.jenis) {
      JenisEntri.transfer =>
        '${entri.namaAkun} → ${entri.namaAkunLawan ?? "-"}',
      _ => entri.namaAkun,
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: warnaIkon.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(ikon, size: 19, color: warnaIkon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entri.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tema.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tema.textTheme.bodySmall
                        ?.copyWith(color: tema.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$tanda${formatRupiah(entri.nominal)}',
              style: tema.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: warnaNominal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}