import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// Overlay transparan yang menampilkan animasi visual proses penyimpanan
/// data onboarding — partikel mengalir masuk, progress mengisi, lalu
/// centang keberhasilan.
class AnimasiProsesOnboarding extends StatefulWidget {
  final Future<bool> prosesSimpan;

  const AnimasiProsesOnboarding({super.key, required this.prosesSimpan});

  @override
  State<AnimasiProsesOnboarding> createState() =>
      _AnimasiProsesOnboardingState();
}

class _AnimasiProsesOnboardingState extends State<AnimasiProsesOnboarding>
    with TickerProviderStateMixin {
  late final AnimationController _kontroler;
  late final AnimationController _putaran;
  final _daftarPartikel = <_Partikel>[];

  @override
  void initState() {
    super.initState();
    _kontroler = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _putaran = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    final acak = Random();
    _daftarPartikel.addAll(List.generate(10, (i) {
      final sudut = (i / 10) * 2 * pi;
      final variasi = (acak.nextDouble() - 0.5) * 0.5;
      return _Partikel(
        sudutDasar: sudut + variasi,
        jarakAwal: 100.0 + acak.nextDouble() * 60.0,
        ukuran: 3.0 + acak.nextDouble() * 2.5,
      );
    }));

    _mulai();
  }

  Future<void> _mulai() async {
    unawaited(widget.prosesSimpan.catchError((_) => false));
    await _kontroler.forward();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _putaran.stop();
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    _kontroler.dispose();
    _putaran.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: Listenable.merge([_kontroler, _putaran]),
          builder: (context, _) {
            final kv = _kontroler.value;
            final selesai = kv > 0.6;

            return Container(
              color: Colors.black.withValues(alpha: 0.6 * _opasitasOverlay(kv)),
              child: CustomPaint(
                size: Size.infinite,
                painter: _PelukisPartikel(
                  daftar: _daftarPartikel,
                  kemajuan: kv,
                  sudutPutaran: _putaran.value * 2 * pi,
                  warna: warna.primary,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLingkaranProgres(kv, selesai, warna),
                      const SizedBox(height: 28),
                      _buildTeksStatus(kv, warna),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double _opasitasOverlay(double kv) => (kv * 5).clamp(0.0, 1.0);

  Widget _buildLingkaranProgres(
    double kv,
    bool selesai,
    ColorScheme warna,
  ) {
    final skala = selesai
        ? Curves.elasticOut.transform(((kv - 0.6) / 0.35).clamp(0.0, 1.0))
        : Curves.elasticOut.transform((kv * 2.5).clamp(0.0, 1.0));

    final nilaiLingkaran = ((kv - 0.05) / 0.6).clamp(0.0, 1.0);

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: nilaiLingkaran,
            strokeWidth: 3,
            color: warna.primary,
            backgroundColor: warna.primaryContainer.withValues(alpha: 0.3),
          ),
          Transform.scale(
            scale: skala,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selesai ? warna.primary : warna.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: (selesai ? warna.primary : warna.primaryContainer)
                        .withValues(alpha: 0.5),
                    blurRadius: selesai ? 40 : 20,
                    spreadRadius: selesai ? 8 : 4,
                  ),
                ],
              ),
              child: Icon(
                selesai ? Icons.check_rounded : Icons.sync_rounded,
                size: 36,
                color: selesai ? Colors.white : warna.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeksStatus(double kv, ColorScheme warna) {
    final teks = kv < 0.15
        ? 'Menyiapkan profil...'
        : kv < 0.6
            ? 'Memproses data...'
            : 'Berhasil!';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        teks,
        key: ValueKey(teks),
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// --- Partikel ---

class _Partikel {
  final double sudutDasar;
  final double jarakAwal;
  final double ukuran;

  _Partikel({
    required this.sudutDasar,
    required this.jarakAwal,
    required this.ukuran,
  });
}

// --- Pelukis ---

class _PelukisPartikel extends CustomPainter {
  final List<_Partikel> daftar;
  final double kemajuan;
  final double sudutPutaran;
  final Color warna;

  _PelukisPartikel({
    required this.daftar,
    required this.kemajuan,
    required this.sudutPutaran,
    required this.warna,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pusat = Offset(size.width / 2, size.height / 2 - 20);
    final cat = Paint()..style = PaintingStyle.fill;

    for (final p in daftar) {
      final sudut = p.sudutDasar + sudutPutaran;
      double jarak;
      double opasitas;

      if (kemajuan < 0.6) {
        final t = Curves.easeIn.transform(
          (kemajuan / 0.6).clamp(0.0, 1.0),
        );
        jarak = p.jarakAwal * (1.0 - t);
        opasitas = 0.3 + t * 0.7;
      } else if (kemajuan < 0.9) {
        final t = Curves.easeOut.transform(
          ((kemajuan - 0.6) / 0.3).clamp(0.0, 1.0),
        );
        jarak = p.jarakAwal * 0.3 + p.jarakAwal * 1.3 * t;
        opasitas = (1.0 - t).clamp(0.0, 1.0);
      } else {
        jarak = 0;
        opasitas = 0;
      }

      final posisi = Offset(
        pusat.dx + cos(sudut) * jarak,
        pusat.dy + sin(sudut) * jarak,
      );

      if (opasitas <= 0) continue;

      cat.color = warna.withValues(alpha: opasitas * 0.3);
      canvas.drawCircle(posisi, p.ukuran * 2.5, cat);
      cat.color = warna.withValues(alpha: opasitas);
      canvas.drawCircle(posisi, p.ukuran, cat);
    }
  }

  @override
  bool shouldRepaint(_PelukisPartikel old) => true;
}
