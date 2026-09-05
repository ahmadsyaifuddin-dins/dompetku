import 'package:flutter/material.dart';

const Color warnaUtama = Color(0xFF0F766E);
const Color warnaUtamaMuda = Color(0xFF14B8A6);

@immutable
class WarnaDompetku extends ThemeExtension<WarnaDompetku> {
  final Color pemasukan;
  final Color pengeluaran;
  final Color netral;

  const WarnaDompetku({
    required this.pemasukan,
    required this.pengeluaran,
    required this.netral,
  });

  static const terang = WarnaDompetku(
    pemasukan: Color(0xFF16A34A),
    pengeluaran: Color(0xFFDC2626),
    netral: Color(0xFF64748B),
  );

  static const gelap = WarnaDompetku(
    pemasukan: Color(0xFF4ADE80),
    pengeluaran: Color(0xFFF87171),
    netral: Color(0xFF94A3B8),
  );

  @override
  WarnaDompetku copyWith({
    Color? pemasukan,
    Color? pengeluaran,
    Color? netral,
  }) {
    return WarnaDompetku(
      pemasukan: pemasukan ?? this.pemasukan,
      pengeluaran: pengeluaran ?? this.pengeluaran,
      netral: netral ?? this.netral,
    );
  }

  @override
  WarnaDompetku lerp(ThemeExtension<WarnaDompetku>? other, double t) {
    if (other is! WarnaDompetku) return this;
    return WarnaDompetku(
      pemasukan: Color.lerp(pemasukan, other.pemasukan, t)!,
      pengeluaran: Color.lerp(pengeluaran, other.pengeluaran, t)!,
      netral: Color.lerp(netral, other.netral, t)!,
    );
  }
}