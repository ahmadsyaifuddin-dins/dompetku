import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app.dart';
import '../../core/services/layanan_fonnte.dart';
import '../../core/services/layanan_preferensi.dart';
import '../../core/theme/pengontrol_tema.dart';
import '../../core/theme/tema_gelap.dart';
import '../../core/theme/tema_terang.dart';
import '../../komponen/tombol/tombol_utama.dart';
import 'onboarding_controller.dart';

/// Halaman awal pemasangan: mengumpulkan nama asli dan nomor WhatsApp
/// pengguna sebelum aplikasi utama terbuka.
class HalamanOnboarding extends StatelessWidget {
  const HalamanOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final pengontrolTema = Get.find<PengontrolTema>();

    return Obx(
      () => GetMaterialApp(
        title: 'DompetKu',
        debugShowCheckedModeBanner: false,
        theme: temaTerangBuild(),
        darkTheme: temaGelapBuild(),
        themeMode: pengontrolTema.themeMode,
        home: const BadanOnboarding(),
      ),
    );
  }
}

class BadanOnboarding extends StatefulWidget {
  const BadanOnboarding({super.key});

  @override
  State<BadanOnboarding> createState() => _BadanOnboardingState();
}

class _BadanOnboardingState extends State<BadanOnboarding>
    with SingleTickerProviderStateMixin {
  late final OnboardingController _pengontrol;
  late final AnimationController _bukaBypass;

  @override
  void initState() {
    super.initState();
    _pengontrol = Get.put(
      OnboardingController(
        layananPreferensi: Get.find<LayananPreferensi>(),
        layananFonnte: Get.find<LayananFonnte>(),
      ),
    );
    _bukaBypass = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _lewati();
        }
      });
  }

  @override
  void dispose() {
    _bukaBypass.dispose();
    super.dispose();
  }

  Future<void> _lewati() async {
    await _pengontrol.lewati();
    if (!mounted) return;
    runApp(const AplikasiDompetKu());
  }

  Future<void> _mulai() async {
    final berhasil = await _pengontrol.simpan();
    if (!berhasil || !mounted) return;
    runApp(const AplikasiDompetKu());
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 16),
            Center(child: _logo(warna)),
            const SizedBox(height: 20),
            Text(
              'Selamat Datang di DompetKu',
              style: tema.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Lengkapi data berikut sekali untuk mulai memakai DompetKu. '
                  'Data hanya tersimpan di perangkatmu.',
              style: tema.textTheme.bodyMedium
                  ?.copyWith(color: warna.onSurfaceVariant, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _pengontrol.namaController,
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nama Asli',
                hintText: 'Misal: Budi Santoso',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pengontrol.nomorController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor WhatsApp',
                hintText: 'Contoh: 081234567890',
                prefixIcon: Icon(Icons.phone_android_rounded),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: warna.errorContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: warna.error),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pastikan nomor WhatsApp yang kamu isi benar dan aktif '
                          'karena dipakai untuk konfirmasi pemasangan. '
                          'Jangan iseng ya!',
                      style: tema.textTheme.bodySmall?.copyWith(
                        color: warna.onErrorContainer,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final pesan = _pengontrol.galat.value;
              if (pesan == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  pesan,
                  style: TextStyle(
                    color: warna.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
            Obx(
              () => TombolUtama(
                label: 'Mulai Menggunakan',
                ikon: Icons.check_rounded,
                pemuatan: _pengontrol.menyimpan.value,
                onDitekan: _mulai,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logo(ColorScheme warna) {
    return SizedBox(
      width: 112,
      height: 112,
      child: GestureDetector(
        onLongPressStart: (_) => _bukaBypass.forward(from: 0),
        onLongPressEnd: (_) => _bukaBypass.reset(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                color: warna.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: 52,
                color: warna.onPrimaryContainer,
              ),
            ),
            AnimatedBuilder(
              animation: _bukaBypass,
              builder: (context, anak) => Padding(
                padding: const EdgeInsets.all(6),
                child: CircularProgressIndicator(
                  value: _bukaBypass.value,
                  strokeWidth: 4,
                  color: warna.primary,
                  backgroundColor: warna.surfaceContainerHighest,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}