import 'package:flutter/material.dart';

/// Bilah navigasi bawah DompetKu — ringan, modern, dengan
/// Centered FAB untuk "Baca dari Gambar".
class BilahNavigasiDompetku extends StatelessWidget {
  final int indeks;
  final ValueChanged<int> padaPilih;
  final VoidCallback padaBacaGambar;

  const BilahNavigasiDompetku({
    super.key,
    required this.indeks,
    required this.padaPilih,
    required this.padaBacaGambar,
  });

  static const _menu = [
    (Icons.home_outlined, Icons.home_rounded, 'Beranda'),
    (Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Transaksi'),
    (Icons.people_alt_outlined, Icons.people_alt_rounded, 'Piutang'),
    (Icons.settings_outlined, Icons.settings_rounded, 'Pengaturan'),
  ];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: warna.surfaceContainer,
        border: Border(
          top: BorderSide(color: warna.outlineVariant),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  for (var i = 0; i < _menu.length; i++) ...[
                    if (i == 2) const SizedBox(width: 16),
                    Expanded(
                      child: _ItemNavigasi(
                        ikon: indeks == i ? _menu[i].$2 : _menu[i].$1,
                        label: _menu[i].$3,
                        aktif: indeks == i,
                        onTap: () => padaPilih(i),
                      ),
                    ),
                    if (i == 2) const SizedBox(width: 16),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            top: -26,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                heroTag: null,
                tooltip: 'Baca dari Gambar',
                onPressed: padaBacaGambar,
                backgroundColor: warna.primary,
                foregroundColor: warna.onPrimary,
                elevation: 4,
                child: const Icon(Icons.document_scanner_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemNavigasi extends StatelessWidget {
  final IconData ikon;
  final String label;
  final bool aktif;
  final VoidCallback onTap;

  const _ItemNavigasi({
    required this.ikon,
    required this.label,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: 46,
            height: 28,
            decoration: BoxDecoration(
              color: aktif
                  ? warna.primary.withValues(alpha: 0.14)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              ikon,
              size: 22,
              color: aktif ? warna.primary : warna.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: aktif ? FontWeight.w700 : FontWeight.w600,
              color: aktif ? warna.primary : warna.onSurfaceVariant,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}