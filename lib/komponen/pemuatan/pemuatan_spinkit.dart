import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum TipePemuatan { piring, titik, gelombang }

class PemuatanSpinkit extends StatelessWidget {
  final TipePemuatan tipe;
  final double ukuran;
  final Color? warna;

  const PemuatanSpinkit({
    super.key,
    this.tipe = TipePemuatan.piring,
    this.ukuran = 36,
    this.warna,
  });

  @override
  Widget build(BuildContext context) {
    final warnaAkhir = warna ?? Theme.of(context).colorScheme.primary;
    return switch (tipe) {
      TipePemuatan.piring => SpinKitFadingCircle(
          size: ukuran,
          color: warnaAkhir,
        ),
      TipePemuatan.titik => SpinKitThreeBounce(
          size: ukuran / 3,
          color: warnaAkhir,
        ),
      TipePemuatan.gelombang => SpinKitWaveSpinner(
          size: ukuran,
          color: warnaAkhir,
        ),
    };
  }
}

class AreaPemuatanSpinkit extends StatelessWidget {
  final String? pesan;

  const AreaPemuatanSpinkit({super.key, this.pesan});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PemuatanSpinkit(),
          if (pesan != null) ...[
            const SizedBox(height: 16),
            Text(
              pesan!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class PemuatanStartup extends StatelessWidget {
  final String judul;

  const PemuatanStartup({super.key, required this.judul});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/logo_app.png',
                width: 96,
                height: 96,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            const PemuatanSpinkit(
              tipe: TipePemuatan.gelombang,
              ukuran: 40,
            ),
            const SizedBox(height: 24),
            Text(judul, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}