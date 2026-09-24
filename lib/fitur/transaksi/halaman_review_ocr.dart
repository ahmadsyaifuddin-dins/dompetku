import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/layanan_preferensi.dart';
import '../../core/utils/format_rupiah.dart';
import '../../core/utils/format_tanggal.dart';
import '../../data/model/enum_dompetku.dart';
import '../../app/routes.dart';
import 'draft_transaksi_ocr.dart';
import 'form_transaksi_controller.dart';
import 'halaman_form_transaksi.dart';

/// Layar periksa hasil OCR: nilai dari mesin ditampilkan untuk dikoreksi
/// sebelum disimpan. Nilai koreksi pengguna menjadi sumber kebenaran final
/// (PRD 15.4). Jenis transaksi bisa diubah bila hasil tebakan mesin keliru.
class HalamanReviewOCR extends StatefulWidget {
  const HalamanReviewOCR({super.key});

  @override
  State<HalamanReviewOCR> createState() => _HalamanReviewOCRState();
}

class _HalamanReviewOCRState extends State<HalamanReviewOCR> {
  late final DraftTransaksiOCR _draft;
  late JenisTransaksi _jenis;
  FormTransaksiController? _pengontrol;

  @override
  void initState() {
    super.initState();
    _draft = Get.arguments as DraftTransaksiOCR;
    _jenis = _draft.jenis;
    _pengontrol = _buatPengontrol(_jenis);
  }

  FormTransaksiController _buatPengontrol(JenisTransaksi jenis) {
    final pengontrol = FormTransaksiController(
      jenis: jenis,
      repositoriTransaksi: Get.find(),
      repositoriAkunDana: Get.find(),
      repositoriKategori: Get.find(),
      layananPreferensi: Get.find<LayananPreferensi>(),
      draft: _draft,
    );
    // Controller ini tidak diregistrasi via Get.put, jadi siklus hidup
    // (onInit -> langganan opsi akun/kategori) harus dijalankan manual.
    pengontrol.onStart();
    return pengontrol;
  }

  void _gantiJenis(JenisTransaksi jenis) {
    if (jenis == _jenis) return;
    setState(() {
      _pengontrol?.onClose();
      _jenis = jenis;
      _pengontrol = _buatPengontrol(jenis);
    });
  }

  @override
  void dispose() {
    _pengontrol?.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tinjau Transaksi')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _kartuHasilOCR(context, _draft),
            const SizedBox(height: 16),
            SegmentedButton<JenisTransaksi>(
              segments: const [
                ButtonSegment(
                  value: JenisTransaksi.pengeluaran,
                  label: Text('Pengeluaran'),
                  icon: Icon(Icons.remove_circle_outline_rounded),
                ),
                ButtonSegment(
                  value: JenisTransaksi.pemasukan,
                  label: Text('Pemasukan'),
                  icon: Icon(Icons.add_circle_outline_rounded),
                ),
              ],
              selected: {_jenis},
              onSelectionChanged: (pilihan) => _gantiJenis(pilihan.first),
            ),
            const SizedBox(height: 16),
            if (_pengontrol != null)
              BadanFormTransaksi(
                pengontrol: _pengontrol!,
                // Setelah simpan dari layar tinjau OCR, jangan kembali ke
                // "Baca dari Gambar; langsung ke daftar transaksi.
                setelahSimpan: () =>
                    Get.offAllNamed(Rute.transaksi),
              ),
          ],
        ),
      ),
    );
  }

  Widget _kartuHasilOCR(BuildContext context, DraftTransaksiOCR draft) {
    final tema = Theme.of(context);
    final rincian = <(IconData, String, String)>[];
    if (draft.nominal > 0) {
      rincian.add((
        Icons.payments_rounded,
        'Nominal terbaca',
        formatRupiah(draft.nominal),
      ));
    }
    rincian.add((
      Icons.event_rounded,
      'Tanggal terbaca',
      formatTanggal(draft.tanggal),
    ));
    if (draft.merchant != null) {
      rincian.add((Icons.storefront_rounded, 'Merchant', draft.merchant!));
    }
    if (draft.metode != null) {
      rincian.add((Icons.account_balance_wallet_rounded, 'Metode', draft.metode!));
    }

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
            if (rincian.isEmpty)
              Text(
                'Belum ada nilai yang terbaca. Lengkapi formulir di bawah.',
                style: TextStyle(color: tema.colorScheme.onSurfaceVariant),
              )
            else
              for (final (ikon, label, nilai) in rincian)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(ikon,
                          size: 16, color: tema.colorScheme.onSurfaceVariant),
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