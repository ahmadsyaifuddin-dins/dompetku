import 'package:flutter/material.dart';

class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: warna.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 48,
                  color: warna.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'DompetKu',
                style: tema.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Versi 1.0.0',
                style: tema.textTheme.bodyMedium
                    ?.copyWith(color: warna.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'DompetKu adalah aplikasi pencatat keuangan pribadi '
                      'yang membantu mengelola akun dana, transaksi, '
                      'transfer, dan piutang secara offline-first. '
                      'Semua data tersimpan aman di perangkatmu.',
                  style: tema.textTheme.bodyMedium?.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pengembang',
              style: tema.textTheme.titleSmall
                  ?.copyWith(color: warna.primary),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: warna.secondaryContainer,
                  foregroundColor: warna.onSecondaryContainer,
                  child: const Icon(Icons.person_rounded),
                ),
                title: const Text('Ahmad Syaifuddin, S.Kom',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Pengembang aplikasi'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.code_rounded),
                title: const Text('Teknologi'),
                subtitle: const Text('Flutter • GetX • Drift'),
                trailing: const Icon(Icons.emoji_objects_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}