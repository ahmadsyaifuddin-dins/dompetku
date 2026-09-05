import 'package:flutter/material.dart';

class TombolUtama extends StatelessWidget {
  final String label;
  final VoidCallback? onDitekan;
  final bool pemuatan;
  final bool lebarPenuh;
  final IconData? ikon;

  const TombolUtama({
    super.key,
    required this.label,
    this.onDitekan,
    this.pemuatan = false,
    this.lebarPenuh = true,
    this.ikon,
  });

  @override
  Widget build(BuildContext context) {
    final tombol = FilledButton(
      onPressed: pemuatan ? null : onDitekan,
      child: pemuatan
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ikon != null) ...[
                  Icon(ikon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );

    if (!lebarPenuh) return tombol;
    return SizedBox(width: double.infinity, child: tombol);
  }
}