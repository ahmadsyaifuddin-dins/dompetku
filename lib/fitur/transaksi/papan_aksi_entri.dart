import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/ringkasan_entri.dart';
import '../../data/repositori/repositori_transaksi.dart';
import '../../data/repositori/repositori_transfer.dart';
import '../../core/services/layanan_saldo.dart';
import '../../core/utils/format_rupiah.dart';
import '../../komponen/snackbar/snackbar_dompetku.dart';
import '../../app/routes.dart';

/// Menampilkan lembar aksi untuk sebuah entri histori
/// (Detail, Edit, dan Hapus).
Future<void> bukaAksiEntri(BuildContext context, EntriHistori entri) async {
  final layanan = Get.find<LayananSaldo>();

  TransaksiData? transaksi;
  TransferData? transfer;
  switch (entri.jenis) {
    case JenisEntri.transfer:
      transfer =
          layanan.transfer.where((t) => t.id == entri.id).firstOrNull;
    case JenisEntri.pemasukan:
    case JenisEntri.pengeluaran:
      transaksi =
          layanan.transaksi.where((t) => t.id == entri.id).firstOrNull;
  }
  if (transaksi == null && transfer == null) return;

  final aksi = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: const Text('Detail'),
              onTap: () => Navigator.pop(sheetContext, 'detail'),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () => Navigator.pop(sheetContext, 'edit'),
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline_rounded,
                color: Theme.of(sheetContext).colorScheme.error,
              ),
              title: Text(
                'Hapus',
                style: TextStyle(
                  color: Theme.of(sheetContext).colorScheme.error,
                ),
              ),
              onTap: () => Navigator.pop(sheetContext, 'hapus'),
            ),
          ],
        ),
      ),
    ),
  );
  if (!context.mounted) return;

  switch (aksi) {
    case 'detail':
      bukaDetailEntri(context, entri, transaksi, transfer);
      break;
    case 'edit':
      if (transaksi != null) {
        Get.toNamed(Rute.tambahTransaksi, arguments: transaksi);
      } else if (transfer != null) {
        Get.toNamed(Rute.tambahTransfer, arguments: transfer);
      }
      break;
    case 'hapus':
      await _konfirmasiHapus(context, entri, transaksi, transfer);
      break;
  }
}

/// Menampilkan detail lengkap sebuah entri histori.
void bukaDetailEntri(
  BuildContext context,
  EntriHistori entri,
  TransaksiData? transaksi,
  TransferData? transfer,
) {
  final layanan = Get.find<LayananSaldo>();
  final kategori = entri.kategoriId == null
      ? null
      : layanan.petaKategori[entri.kategoriId];

  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entri.label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${entri.jenis == JenisEntri.pemasukan ? "+" : entri.jenis == JenisEntri.pengeluaran ? "-" : ""}'
              '${formatRupiah(entri.nominal)}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: entri.jenis == JenisEntri.transfer
                    ? Theme.of(sheetContext).colorScheme.primary
                    : null,
              ),
            ),
            const Divider(height: 32),
            _BarisDetail(
              label: 'Tanggal',
              nilai:
                  '${entri.tanggal.day}/${entri.tanggal.month}/${entri.tanggal.year}',
            ),
            _BarisDetail(label: 'Jenis', nilai: switch (entri.jenis) {
              JenisEntri.pemasukan => 'Pemasukan',
              JenisEntri.pengeluaran => 'Pengeluaran',
              JenisEntri.transfer => 'Transfer',
            }),
            if (entri.jenis == JenisEntri.transfer) ...[
              _BarisDetail(label: 'Dari', nilai: entri.namaAkun),
              _BarisDetail(
                label: 'Ke',
                nilai: entri.namaAkunLawan ?? '-',
              ),
            ] else
              _BarisDetail(label: 'Akun', nilai: entri.namaAkun),
            if (kategori != null)
              _BarisDetail(label: 'Kategori', nilai: kategori.nama),
            if (entri.catatan != null && entri.catatan!.isNotEmpty)
              _BarisDetail(label: 'Catatan', nilai: entri.catatan!),
          ],
        ),
      ),
    ),
  );
}

Future<void> _konfirmasiHapus(
  BuildContext context,
  EntriHistori entri,
  TransaksiData? transaksi,
  TransferData? transfer,
) async {
  await AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    title: 'Hapus Catatan?',
    desc: '${entri.label} sebesar ${formatRupiah(entri.nominal)} '
        'akan dihapus dari riwayat.',
    btnCancelText: 'Batal',
    btnOkText: 'Hapus',
    btnOkColor: Theme.of(context).colorScheme.error,
    btnCancelOnPress: () {},
    btnOkOnPress: () async {
      try {
        if (transaksi != null) {
          await Get.find<RepositoriTransaksi>().hapus(transaksi.id);
        } else if (transfer != null) {
          await Get.find<RepositoriTransfer>().hapus(transfer.id);
        }
        tampilkanSnackbarDompetku(
          jenis: JenisSnackbar.sukses,
          judul: 'Berhasil',
          pesan: 'Catatan dihapus.',
        );
      } catch (_) {
        tampilkanSnackbarDompetku(
          jenis: JenisSnackbar.galat,
          judul: 'Gagal',
          pesan: 'Terjadi kesalahan saat menghapus catatan.',
        );
      }
    },
  ).show();
}

class _BarisDetail extends StatelessWidget {
  final String label;
  final String nilai;

  const _BarisDetail({required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              nilai,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}