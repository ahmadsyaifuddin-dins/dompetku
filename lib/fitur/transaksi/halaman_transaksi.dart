import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/enum_dompetku.dart';
import '../../data/model/ringkasan_entri.dart';
import '../../inti/layanan/layanan_saldo.dart';
import '../../inti/utilitas/format_tanggal.dart';
import '../../komponen/kartu/kartu_entri_histori.dart';
import '../../komponen/keadaan/keadaan_kosong.dart';
import '../../komponen/pemuatan/pemuatan_shimmer.dart';
import '../../utama/rute.dart';
import 'histori_controller.dart';
import 'papan_aksi_entri.dart';

class HalamanTransaksi extends StatelessWidget {
  const HalamanTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    final pengontrol = Get.put(
      HistoriController(layananSaldo: Get.find<LayananSaldo>()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
        actions: [
          Obx(
            () => IconButton(
              tooltip: 'Filter',
              onPressed: () => _bukaFilter(context, pengontrol),
              icon: Badge(
                isLabelVisible: pengontrol.punyaFilter,
                child: const Icon(Icons.filter_list_rounded),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _bukaMenuTambah(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Catat'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _chipFilter(
                      context,
                      label: 'Semua',
                      aktif: pengontrol.filter.value == null,
                      onTap: () => pengontrol.filter.value = null,
                    ),
                    _chipFilter(
                      context,
                      label: 'Pemasukan',
                      aktif: pengontrol.filter.value == JenisEntri.pemasukan,
                      onTap: () =>
                          pengontrol.filter.value = JenisEntri.pemasukan,
                    ),
                    _chipFilter(
                      context,
                      label: 'Pengeluaran',
                      aktif: pengontrol.filter.value == JenisEntri.pengeluaran,
                      onTap: () =>
                          pengontrol.filter.value = JenisEntri.pengeluaran,
                    ),
                    _chipFilter(
                      context,
                      label: 'Transfer',
                      aktif: pengontrol.filter.value == JenisEntri.transfer,
                      onTap: () =>
                          pengontrol.filter.value = JenisEntri.transfer,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final layanan = Get.find<LayananSaldo>();
              if (layanan.pemuatan.value) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    KartuSkeletonTransaksi(),
                    SizedBox(height: 12),
                    KartuSkeletonTransaksi(),
                    SizedBox(height: 12),
                    KartuSkeletonTransaksi(),
                  ],
                );
              }
              final histori = pengontrol.histori;
              if (histori.isEmpty) {
                return KeadaanKosong(
                  ikon: Icons.receipt_long_rounded,
                  judul: pengontrol.punyaFilter
                      ? 'Tidak ada yang cocok'
                      : 'Tidak ada catatan',
                  pesan: pengontrol.punyaFilter
                      ? 'Coba ubah atau hapus filter untuk melihat '
                          'catatan lain.'
                      : 'Ketuk tombol Catat untuk menambahkan '
                          'transaksi atau transfer.',
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: histori.length,
                itemBuilder: (context, indeks) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: KartuEntriHistori(
                    entri: histori[indeks],
                    onTap: () => bukaAksiEntri(context, histori[indeks]),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  static const _kodeSemua = '';

  void _bukaFilter(BuildContext context, HistoriController pengontrol) {
    final layanan = Get.find<LayananSaldo>();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filter Transaksi',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Obx(
                    () => TextButton(
                      onPressed: pengontrol.punyaFilter
                          ? () {
                              pengontrol.resetKriteria();
                              Navigator.pop(sheetContext);
                            }
                          : null,
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Obx(() {
                final nilai = pengontrol.kategori.value;
                final kategoriAman =
                    nilai != null && layanan.petaKategori.containsKey(nilai)
                        ? nilai
                        : null;
                return DropdownButtonFormField<String>(
                  key: ValueKey(kategoriAman),
                  initialValue: kategoriAman,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String>(
                      value: _kodeSemua,
                      child: Text('Semua kategori'),
                    ),
                    ...layanan.kategori.map(
                      (kategoriData) => DropdownMenuItem<String>(
                        value: kategoriData.id,
                        child: Text(kategoriData.nama),
                      ),
                    ),
                  ],
                  onChanged: (nilaiBaru) => pengontrol.kategori.value =
                      (nilaiBaru == null || nilaiBaru == _kodeSemua)
                          ? null
                          : nilaiBaru,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: Icon(Icons.label_outline_rounded),
                    border: OutlineInputBorder(),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Obx(() {
                final nilai = pengontrol.akun.value;
                final akunAman =
                    nilai != null && layanan.petaAkun.containsKey(nilai)
                        ? nilai
                        : null;
                return DropdownButtonFormField<String>(
                  key: ValueKey(akunAman),
                  initialValue: akunAman,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String>(
                      value: _kodeSemua,
                      child: Text('Semua akun'),
                    ),
                    ...layanan.akun.map(
                      (akunData) => DropdownMenuItem<String>(
                        value: akunData.id,
                        child: Text(akunData.nama),
                      ),
                    ),
                  ],
                  onChanged: (nilaiBaru) => pengontrol.akun.value =
                      (nilaiBaru == null || nilaiBaru == _kodeSemua)
                          ? null
                          : nilaiBaru,
                  decoration: const InputDecoration(
                    labelText: 'Akun dana',
                    prefixIcon: Icon(Icons.account_balance_wallet_rounded),
                    border: OutlineInputBorder(),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _tombolTanggalFilter(
                        context: sheetContext,
                        judul: 'Dari',
                        tanggal: pengontrol.tanggalAwal.value,
                        onPilih: (t) => pengontrol.tanggalAwal.value = t,
                        onHapus: () => pengontrol.tanggalAwal.value = null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _tombolTanggalFilter(
                        context: sheetContext,
                        judul: 'Sampai',
                        tanggal: pengontrol.tanggalAkhir.value,
                        onPilih: (t) => pengontrol.tanggalAkhir.value = t,
                        onHapus: () => pengontrol.tanggalAkhir.value = null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tombolTanggalFilter({
    required BuildContext context,
    required String judul,
    required DateTime? tanggal,
    required ValueChanged<DateTime> onPilih,
    required VoidCallback onHapus,
  }) {
    return OutlinedButton.icon(
      onPressed: () async {
        final dipilih = await showDatePicker(
          context: context,
          initialDate: tanggal ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          helpText: 'Pilih Tanggal $judul',
        );
        if (dipilih != null) onPilih(dipilih);
      },
      icon: const Icon(Icons.date_range_rounded),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              tanggal == null ? judul : formatTanggal(tanggal),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: tanggal == null
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : null,
              ),
            ),
          ),
          if (tanggal != null) ...[
            const SizedBox(width: 4),
            InkWell(
              onTap: onHapus,
              child: const Icon(
                Icons.clear_rounded,
                size: 16,
                color: Colors.redAccent,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chipFilter(
    BuildContext context, {
    required String label,
    required bool aktif,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: aktif,
        showCheckmark: false,
        onSelected: (_) => onTap(),
      ),
    );
  }

  void _bukaMenuTambah(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Catat Transaksi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            _aksiMenu(
              context,
              ikon: Icons.add_circle_rounded,
              label: 'Pemasukan',
              onTap: () {
                Navigator.pop(sheetContext);
                Get.toNamed(Rute.tambahTransaksi,
                    arguments: JenisTransaksi.pemasukan);
              },
            ),
            _aksiMenu(
              context,
              ikon: Icons.remove_circle_rounded,
              label: 'Pengeluaran',
              onTap: () {
                Navigator.pop(sheetContext);
                Get.toNamed(Rute.tambahTransaksi,
                    arguments: JenisTransaksi.pengeluaran);
              },
            ),
            _aksiMenu(
              context,
              ikon: Icons.swap_horiz_rounded,
              label: 'Transfer',
              onTap: () {
                Navigator.pop(sheetContext);
                Get.toNamed(Rute.tambahTransfer);
              },
            ),
            _aksiMenu(
              context,
              ikon: Icons.account_balance_wallet_rounded,
              label: 'Pinjaman',
              onTap: () {
                Navigator.pop(sheetContext);
                Get.toNamed(Rute.tambahPiutang);
              },
            ),
            _aksiMenu(
              context,
              ikon: Icons.document_scanner_outlined,
              label: 'Baca dari Gambar',
              onTap: () {
                Navigator.pop(sheetContext);
                Get.toNamed(Rute.bacaGambar);
              },
            ),
            _aksiMenu(
              context,
              ikon: Icons.trending_up_rounded,
              label: 'Investasi',
              terkunci: true,
              onTap: () {},
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      ),
    );
  }

  Widget _aksiMenu(
    BuildContext context, {
    required IconData ikon,
    required String label,
    required VoidCallback onTap,
    bool terkunci = false,
    Color? warna,
  }) {
    final warnaAkhir = warna ?? Theme.of(context).colorScheme.primary;
    return ListTile(
      leading: Icon(ikon,
          color: terkunci ? Theme.of(context).disabledColor : warnaAkhir),
      title: Text(
        label,
        style: TextStyle(
          color: terkunci ? Theme.of(context).disabledColor : null,
        ),
      ),
      enabled: !terkunci,
      onTap: onTap,
    );
  }
}