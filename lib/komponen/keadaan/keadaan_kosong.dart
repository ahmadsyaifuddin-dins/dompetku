import 'package:flutter/material.dart';

class KeadaanKosong extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String pesan;
  final Widget? aksi;

  const KeadaanKosong({
    super.key,
    required this.ikon,
    required this.judul,
    required this.pesan,
    this.aksi,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: warna.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(ikon, size: 40, color: warna.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            Text(
              judul,
              style: tema.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              pesan,
              style: tema.textTheme.bodyMedium
                  ?.copyWith(color: warna.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (aksi != null) ...[
              const SizedBox(height: 20),
              aksi!,
            ],
          ],
        ),
      ),
    );
  }
}