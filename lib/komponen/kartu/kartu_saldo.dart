import 'package:flutter/material.dart';

import '../../inti/tema/warna_tema.dart';
import '../../inti/utilitas/format_rupiah.dart';

/// Kartu saldo unggulan beranda — permukaan emerald pekat, nomor dominan.
class KartuSaldo extends StatelessWidget {
  final String judul;
  final String nominal;
  final int? selisih;

  const KartuSaldo({
    super.key,
    required this.judul,
    required this.nominal,
    this.selisih,
  });

  @override
  Widget build(BuildContext context) {
    final warnaDompetku = Theme.of(context).extension<WarnaDompetku>()!;
    final warnaTeks = warnaDompetku.onPermukaanSaldo;
    final selisihNilai = selisih;
    final positif = selisihNilai == null || selisihNilai >= 0;
    final warnaSelisih = positif
        ? Color.lerp(warnaTeks, warnaDompetku.pemasukan, 0.35)!
        : Color.lerp(warnaTeks, warnaDompetku.pengeluaran, 0.35)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      decoration: BoxDecoration(
        color: warnaDompetku.permukaanSaldo,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: warnaTeks.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  judul,
                  style: TextStyle(
                    color: warnaTeks.withValues(alpha: 0.72),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 18,
                color: warnaTeks.withValues(alpha: 0.55),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              nominal,
              maxLines: 1,
              style: TextStyle(
                color: warnaTeks,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -0.5,
              ),
            ),
          ),
          if (selisihNilai != null) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  positif
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: 16,
                  color: warnaSelisih,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '${positif ? '+' : '-'}${formatRupiah(selisihNilai.abs())} '
                    'bulan ini',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: warnaSelisih,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}