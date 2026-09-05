import 'package:flutter/material.dart';

import '../../data/model/ringkasan_entri.dart';
import '../../inti/tema/warna_tema.dart';
import '../../inti/utilitas/format_rupiah.dart';

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
    final warnaDompetku = Theme.of(context).extension<WarnaDompetku>()!;
    final tua = Theme.of(context).colorScheme;

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
          tua.primary,
        ),
    };

    final (tanda, warnaNominal) = switch (entri.jenis) {
      JenisEntri.pemasukan => ('+', warnaDompetku.pemasukan),
      JenisEntri.pengeluaran => ('-', warnaDompetku.pengeluaran),
      JenisEntri.transfer => ('', tua.primary),
    };

    final subtitle = switch (entri.jenis) {
      JenisEntri.transfer =>
        '${entri.namaAkun} → ${entri.namaAkunLawan ?? "-"}',
      _ => entri.namaAkun,
    };

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: warnaIkon.withValues(alpha: 0.14),
          foregroundColor: warnaIkon,
          child: Icon(ikon, size: 22),
        ),
        title: Text(
          entri.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          '$tanda${formatRupiah(entri.nominal)}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: warnaNominal,
          ),
        ),
      ),
    );
  }
}