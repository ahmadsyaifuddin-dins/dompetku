import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes.dart';
import '../../core/services/layanan_fonnte.dart';
import '../../core/services/layanan_preferensi.dart';
import '../../komponen/debug/log_debug.dart';
import '../../komponen/debug/panel_debug.dart';
import '../../komponen/tombol/tombol_utama.dart';
import 'animasi_proses_onboarding.dart';
import 'onboarding_controller.dart';

/// Halaman awal pemasangan: mengumpulkan nama asli
/// dan nomor WhatsApp pengguna sebelum aplikasi utama dibuka.
class HalamanOnboarding extends StatefulWidget {
  const HalamanOnboarding({
    super.key,
  });

  @override
  State<HalamanOnboarding> createState() =>
      _HalamanOnboardingState();
}

class _HalamanOnboardingState
    extends State<HalamanOnboarding> {
  final _tampilkanDebug = ValueNotifier<bool>(false);

  late final OnboardingController _pengontrol;

  @override
  void initState() {
    super.initState();

    _pengontrol = Get.isRegistered<OnboardingController>()
        ? Get.find<OnboardingController>()
        : Get.put(
            OnboardingController(
              layananPreferensi:
                  Get.find<LayananPreferensi>(),
              layananFonnte:
                  Get.find<LayananFonnte>(),
            ),
          );

    // Pengaman:
    // bila onboarding somehow terbuka padahal status
    // sudah_instal sudah true, langsung kembali ke halaman utama.
    if (_pengontrol.sudahInstal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        DebugLog.saya.tulis(
          '⚠ sudah_instal=true saat onboarding terbuka; '
          'dialihkan ke utama.',
        );

        Get.offAllNamed(
          Rute.halamanInduk,
        );
      });
    }
  }

  @override
  void dispose() {
    _tampilkanDebug.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 16),

                Center(
                  child: _logo(warna),
                ),

                const SizedBox(height: 20),

                Text(
                  'Selamat Datang di DompetKu',
                  style: tema.textTheme.headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Lengkapi data berikut sekali untuk '
                  'mulai memakai DompetKu. '
                  'Data hanya tersimpan di perangkatmu.',
                  style: tema.textTheme.bodyMedium
                      ?.copyWith(
                        color: warna.onSurfaceVariant,
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                TextField(
                  controller:
                      _pengontrol.namaController,
                  textCapitalization:
                      TextCapitalization.words,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Nama Asli',
                    hintText: 'Misal: Budi Santoso',
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller:
                      _pengontrol.nomorController,
                  keyboardType:
                      TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Nomor WhatsApp',
                    hintText: 'Contoh: 081234567890',
                    prefixIcon: Icon(
                      Icons.phone_android_rounded,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: warna.errorContainer
                        .withValues(alpha: 0.35),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: warna.error,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Pastikan nomor WhatsApp yang '
                          'kamu isi benar dan aktif karena '
                          'dipakai untuk konfirmasi '
                          'pemasangan. Jangan iseng ya!',
                          style: tema.textTheme.bodySmall
                              ?.copyWith(
                                color:
                                    warna.onErrorContainer,
                                height: 1.4,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Obx(() {
                  final pesan =
                      _pengontrol.galat.value;

                  if (pesan == null) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8),
                    child: Text(
                      pesan,
                      style: TextStyle(
                        color: warna.error,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  );
                }),

                Obx(
                  () => TombolUtama(
                    label: 'Mulai Menggunakan',
                    ikon: Icons.check_rounded,
                    pemuatan: _pengontrol.menyimpan.value,
                    onDitekan: () async {
                      _tampilkanDebug.value = true;

                      // Jalankan fungsi simpan secara langsung agar tidak dipotong
                      // oleh widget animasi pihak ketiga.
                      final berhasil = await _pengontrol.simpan();

                      if (!mounted) return;

                      // Validasi murni menggunakan hasil balikan dari controller
                      if (berhasil == true) {
                        DebugLog.saya.tulis(
                          '✓ Proses selesai; menuju halaman utama.',
                        );
                        
                        Get.offAllNamed(Rute.halamanInduk);
                      } else {
                        DebugLog.saya.tulis(
                          '⚠ Proses ditolak karena galat atau validasi gagal.',
                        );
                      }
                    },
                  ),
                ),
              ],
            ),

            Positioned(
              top: 8,
              right: 8,
              child: SaklarPanelDebug(
                terbuka: _tampilkanDebug,
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: PanelDebug(
                terbuka: _tampilkanDebug,
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