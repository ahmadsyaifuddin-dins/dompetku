import 'package:flutter/material.dart';

/// Identitas visual DompetKu: emerald sebagai warna utama.
const Color warnaEmerald = Color(0xFF0E7A5F);
const Color warnaEmeraldMuda = Color(0xFF34D399);
const Color warnaLimeMuda = Color(0xFFA3C75C);

@immutable
class WarnaDompetku extends ThemeExtension<WarnaDompetku> {
  final Color pemasukan;
  final Color pengeluaran;
  final Color netral;
  final Color aksen;
  final Color aksenLembut;
  final Color permukaanSaldo;
  final Color onPermukaanSaldo;

  const WarnaDompetku({
    required this.pemasukan,
    required this.pengeluaran,
    required this.netral,
    required this.aksen,
    required this.aksenLembut,
    required this.permukaanSaldo,
    required this.onPermukaanSaldo,
  });

  static const terang = WarnaDompetku(
    pemasukan: Color(0xFF15803D),
    pengeluaran: Color(0xFFC0392B),
    netral: Color(0xFF8A9390),
    aksen: Color(0xFF0E7A5F),
    aksenLembut: Color(0xFF5B8C3E),
    permukaanSaldo: Color(0xFF0B3328),
    onPermukaanSaldo: Color(0xFFF2F7F4),
  );

  static const gelap = WarnaDompetku(
    pemasukan: Color(0xFF4ADE80),
    pengeluaran: Color(0xFFF27777),
    netral: Color(0xFF9FAAA5),
    aksen: Color(0xFF34D399),
    aksenLembut: Color(0xFFB7D986),
    permukaanSaldo: Color(0xFF0F2E24),
    onPermukaanSaldo: Color(0xFFE8F5EE),
  );

  @override
  WarnaDompetku copyWith({
    Color? pemasukan,
    Color? pengeluaran,
    Color? netral,
    Color? aksen,
    Color? aksenLembut,
    Color? permukaanSaldo,
    Color? onPermukaanSaldo,
  }) {
    return WarnaDompetku(
      pemasukan: pemasukan ?? this.pemasukan,
      pengeluaran: pengeluaran ?? this.pengeluaran,
      netral: netral ?? this.netral,
      aksen: aksen ?? this.aksen,
      aksenLembut: aksenLembut ?? this.aksenLembut,
      permukaanSaldo: permukaanSaldo ?? this.permukaanSaldo,
      onPermukaanSaldo: onPermukaanSaldo ?? this.onPermukaanSaldo,
    );
  }

  @override
  WarnaDompetku lerp(ThemeExtension<WarnaDompetku>? other, double t) {
    if (other is! WarnaDompetku) return this;
    return WarnaDompetku(
      pemasukan: Color.lerp(pemasukan, other.pemasukan, t)!,
      pengeluaran: Color.lerp(pengeluaran, other.pengeluaran, t)!,
      netral: Color.lerp(netral, other.netral, t)!,
      aksen: Color.lerp(aksen, other.aksen, t)!,
      aksenLembut: Color.lerp(aksenLembut, other.aksenLembut, t)!,
      permukaanSaldo: Color.lerp(permukaanSaldo, other.permukaanSaldo, t)!,
      onPermukaanSaldo:
          Color.lerp(onPermukaanSaldo, other.onPermukaanSaldo, t)!,
    );
  }
}