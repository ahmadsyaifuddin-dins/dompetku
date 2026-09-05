import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/enum_dompetku.dart';
import '../../inti/tema/pengontrol_tema.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    final pengontrolTema = Get.find<PengontrolTema>();
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Tampilan',
            style: tema.textTheme.titleSmall
                ?.copyWith(color: tema.colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Card(
            child: Obx(
              () => RadioGroup<ModeTema>(
                groupValue: pengontrolTema.modeTema,
                onChanged: (mode) {
                  if (mode != null) pengontrolTema.aturModeTema(mode);
                },
                child: Column(
                  children: [
                    RadioListTile<ModeTema>(
                      value: ModeTema.system,
                      activeColor: tema.colorScheme.primary,
                      secondary: const Icon(Icons.brightness_auto_rounded),
                      title: const Text('System'),
                      subtitle: const Text('Mengikuti tema perangkat'),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    RadioListTile<ModeTema>(
                      value: ModeTema.terang,
                      activeColor: tema.colorScheme.primary,
                      secondary: const Icon(Icons.light_mode_rounded),
                      title: const Text('Terang'),
                      subtitle: const Text('Mode terang selalu'),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    RadioListTile<ModeTema>(
                      value: ModeTema.gelap,
                      activeColor: tema.colorScheme.primary,
                      secondary: const Icon(Icons.dark_mode_rounded),
                      title: const Text('Gelap'),
                      subtitle: const Text('Mode gelap selalu'),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Lainnya',
            style: tema.textTheme.titleSmall
                ?.copyWith(color: tema.colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet_rounded),
                  title: const Text('Akun Dana'),
                  subtitle: const Text('Kelola sumber dana'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _belumTersedia(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.category_rounded),
                  title: const Text('Kategori'),
                  subtitle: const Text('Kelola kategori transaksi'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _belumTersedia(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('Informasi Aplikasi'),
                  subtitle: const Text('Versi DompetKu'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _belumTersedia(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _belumTersedia() {
    Get.snackbar(
      'Segera hadir',
      'Fitur ini masih dalam pengembangan.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}