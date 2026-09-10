import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../inti/utilitas/format_rupiah.dart';
import '../../inti/utilitas/format_tanggal.dart';
import 'draft_transaksi_ocr.dart';
import 'form_transaksi_controller.dart';
import 'halaman_form_transaksi.dart';

/// Layar periksa hasil OCR: nilai dari mesin ditampilkan untuk dikoreksi
/// sebelum disimpan. Nilai koreksi pengguna menjadi sumber kebenaran final
/// (PRD 15.4).
class HalamanReviewOCR extends StatelessWidget {
  const HalamanReviewOCR({super.key});

  @override
  Widget build(BuildContext context) {
    final draft = Get.arguments as DraftTransaksiOCR;
    final pengontrol = Get.put(FormTransaksiController(
      jenis: draft.jenis,
      repositoriTransaksi: Get.find(),
      repositoriAkunDana: Get.find(),
      repositoriKategori: Get.find(),
      draft: draft,
    ));

    return Scaffold(
      appBar: AppBar(title: const Text('Tinjau Transaksi')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _kartuHasilOCR(context, draft),
            const SizedBox(height: 16),
            BadanFormTransaksi(pengontrol: pengontrol),
          ],
        ),
      ),
    );
  }

  Widget _kartuHasilOCR(BuildContext context, DraftTransaksiOCR draft) {
    final tema = Theme.of(context);
    final rincian = <(IconData, String, String)>[
      (
        Icons.payments_rounded,
        'Nominal terbaca',
        formatRupiah(draft.nominal),
      ),
      (
        Icons.event_rounded,
        'Tanggal terbaca',
        formatTanggal(draft.tanggal),
      ),
      if (draft.merchant != null)
        (Icons.storefront_rounded, 'Merchant', draft.merchant!),
      if (draft.metode != null)
        (Icons.account_balance_wallet_rounded, 'Metode', draft.metode!),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.document_scanner_rounded,
                    color: tema.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Hasil OCR',
                  style: tema.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Periksa dan koreksi sebelum disimpan.',
              style: tema.textTheme.bodySmall?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            for (final (ikon, label, nilai) in rincian)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(ikon, size: 16, color: tema.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$label: $nilai',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                'Teks asli',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              childrenPadding: const EdgeInsets.only(bottom: 8),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    draft.teksMentah,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}