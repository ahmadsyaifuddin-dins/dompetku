import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes.dart';
import '../../core/services/layanan_fonnte.dart';
import '../../core/services/layanan_preferensi.dart';
import '../../komponen/tombol/tombol_utama.dart';
import 'animasi_proses_onboarding.dart';
import 'onboarding_controller.dart';

/// Halaman awal pemasangan: mengumpulkan nama asli dan nomor WhatsApp
/// pengguna sebelum aplikasi utama terbuka.
class HalamanOnboarding extends StatelessWidget {
  const HalamanOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    final pengontrol = Get.put(
      OnboardingController(
        layananPreferensi: Get.find<LayananPreferensi>(),
        layananFonnte: Get.find<LayananFonnte>(),
      ),
    );

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
              controller: pengontrol.namaController,
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
              controller: pengontrol.nomorController,
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
              final pesan = pengontrol.galat.value;
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
                pemuatan: pengontrol.menyimpan.value,
                onDitekan: () async {
                  final berhasil = await Navigator.of(context).push<bool>(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (konteks, animasi, energi) =>
                          AnimasiProsesOnboarding(
                        prosesSimpan: pengontrol.simpan(),
                      ),
                      transitionsBuilder: (konteks, animasi, energi, child) =>
                          FadeTransition(opacity: animasi, child: child),
                    ),
                  );
                  if (berhasil == true) {
                    Get.offAllNamed(Rute.halamanInduk);
                  }
                },
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
      child: Container(
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
    );
  }
}
