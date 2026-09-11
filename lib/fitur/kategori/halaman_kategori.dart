import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../data/repositori/repositori_kategori.dart';
import '../../inti/konstanta/ikon_map.dart';
import '../../inti/layanan/layanan_preferensi.dart';
import '../../komponen/keadaan/keadaan_kosong.dart';
import '../../komponen/snackbar/snackbar_dompetku.dart';
import '../../komponen/tombol/tombol_utama.dart';
import 'kategori_controller.dart';

enum _AksiKategori { aturBawaan, nonaktifkan }

class HalamanKategori extends StatelessWidget {
  const HalamanKategori({super.key});

  @override
  Widget build(BuildContext context) {
    final pengontrol = Get.put(
      KategoriController(
        repositori: Get.find<RepositoriKategori>(),
        layananPreferensi: Get.find<LayananPreferensi>(),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaFormTambah(context, pengontrol),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Obx(
              () => SegmentedButton<JenisTransaksi>(
                segments: const [
                  ButtonSegment(
                    value: JenisTransaksi.pengeluaran,
                    label: Text('Pengeluaran'),
                  ),
                  ButtonSegment(
                    value: JenisTransaksi.pemasukan,
                    label: Text('Pemasukan'),
                  ),
                ],
                selected: {pengontrol.tab.value},
                onSelectionChanged: (pilihan) {
                  pengontrol.tab.value = pilihan.first;
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final jenis = pengontrol.tab.value;
              final aktif = pengontrol.aktifUntuk(jenis);
              final nonaktif = pengontrol
                  .untuk(jenis)
                  .where((k) => !k.aktif)
                  .toList();
              if (aktif.isEmpty && nonaktif.isEmpty) {
                return KeadaanKosong(
                  ikon: Icons.category_rounded,
                  judul: 'Belum ada kategori',
                  pesan: 'Ketuk tombol Tambah untuk membuat kategori '
                      '${jenis == JenisTransaksi.pemasukan ? "pemasukan" : "pengeluaran"}.',
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...aktif.map(
                    (kategori) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _kartuKategori(context, pengontrol, kategori),
                    ),
                  ),
                  if (nonaktif.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Tidak Aktif',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    ...nonaktif.map(
                      (kategori) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _kartuKategori(context, pengontrol, kategori),
                      ),
                    ),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _kartuKategori(
    BuildContext context,
    KategoriController pengontrol,
    KategoriData kategori,
  ) {
    final tema = Theme.of(context);
    final bawaan = pengontrol.bawaanUntuk(kategori.jenis) == kategori.id;
    final Text? keterangan;
    if (kategori.aktif && bawaan) {
      keterangan = Text(
        'Bawaan saat mencatat',
        style: TextStyle(
          color: tema.colorScheme.onSurfaceVariant,
        ),
      );
    } else if (!kategori.aktif) {
      keterangan = Text(
        'Tidak aktif',
        style: TextStyle(
          color: tema.colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      );
    } else {
      keterangan = null;
    }
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tema.colorScheme.surfaceContainerHighest,
          foregroundColor: tema.colorScheme.onSurfaceVariant,
          child: Icon(ikonUntukKategori(kategori.ikon)),
        ),
        title: Text(kategori.nama),
        subtitle: keterangan,
        trailing: kategori.aktif
            ? PopupMenuButton<_AksiKategori>(
                tooltip: 'Opsi Kategori',
                onSelected: (aksi) => _pilihAksi(
                  context,
                  pengontrol,
                  kategori,
                  aksi,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _AksiKategori.aturBawaan,
                    child: Row(
                      children: [
                        Icon(
                          bawaan
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: bawaan
                              ? tema.colorScheme.primary
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          bawaan ? 'Hapus Bawaan' : 'Jadikan Bawaan',
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: _AksiKategori.nonaktifkan,
                    child: Row(
                      children: [
                        Icon(Icons.visibility_off_rounded),
                        SizedBox(width: 12),
                        Text('Nonaktifkan'),
                      ],
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  void _pilihAksi(
    BuildContext context,
    KategoriController pengontrol,
    KategoriData kategori,
    _AksiKategori aksi,
  ) {
    switch (aksi) {
      case _AksiKategori.aturBawaan:
        _setelBawaan(context, pengontrol, kategori);
      case _AksiKategori.nonaktifkan:
        _konfirmasiNonaktifkan(context, pengontrol, kategori);
    }
  }

  Future<void> _setelBawaan(
    BuildContext context,
    KategoriController pengontrol,
    KategoriData kategori,
  ) async {
    final jenis = kategori.jenis == JenisTransaksi.pemasukan
        ? 'pemasukan'
        : 'pengeluaran';
    final sudahBawaan =
        pengontrol.bawaanUntuk(kategori.jenis) == kategori.id;
    if (sudahBawaan) {
      await pengontrol.hapusBawaan(kategori.jenis);
      tampilkanSnackbarDompetku(
        jenis: JenisSnackbar.sukses,
        judul: 'Berhasil',
        pesan: 'Kategori bawaan untuk $jenis dihapus.',
      );
    } else {
      await pengontrol.aturBawaan(kategori);
      tampilkanSnackbarDompetku(
        jenis: JenisSnackbar.sukses,
        judul: 'Berhasil',
        pesan: '${kategori.nama} dipilih otomatis saat '
            'mencatat $jenis.',
      );
    }
  }

  void _konfirmasiNonaktifkan(
    BuildContext context,
    KategoriController pengontrol,
    KategoriData kategori,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: 'Nonaktifkan Kategori?',
      desc: '${kategori.nama} tidak akan muncul sebagai pilihan, '
          'namun riwayat transaksi yang memakainya tetap tersimpan.',
      btnCancelText: 'Batal',
      btnOkText: 'Nonaktifkan',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        final berhasil = await pengontrol.nonaktifkan(kategori);
        if (!berhasil || pengontrol.galat.value != null) {
          tampilkanSnackbarDompetku(
            jenis: JenisSnackbar.galat,
            judul: 'Gagal',
            pesan: pengontrol.galat.value ?? 'Terjadi kesalahan.',
          );
          return;
        }
        tampilkanSnackbarDompetku(
          jenis: JenisSnackbar.sukses,
          judul: 'Berhasil',
          pesan: 'Kategori ${kategori.nama} dinonaktifkan.',
        );
      },
    ).show();
  }

  void _bukaFormTambah(
    BuildContext context,
    KategoriController pengontrol,
  ) {
    Get.bottomSheet(
      isScrollControlled: true,
      _FormTambahKategori(pengontrol: pengontrol),
    );
  }
}

class _FormTambahKategori extends StatelessWidget {
  final KategoriController pengontrol;

  const _FormTambahKategori({required this.pengontrol});

  @override
  Widget build(BuildContext context) {
    final jenis = pengontrol.tab.value;
    final kunciIkon = jenis == JenisTransaksi.pemasukan
        ? kunciIkonKategoriPemasukan
        : kunciIkonKategoriPengeluaran;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tambah Kategori',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: pengontrol.namaController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nama Kategori',
              hintText: 'Contoh: Makanan',
              prefixIcon: Icon(Icons.edit_rounded),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pilih Ikon',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: kunciIkon.map((kunci) {
                final terpilih =
                    (pengontrol.ikon.value ?? kunciIkon.first) == kunci;
                return ChoiceChip(
                  avatar: Icon(ikonUntukKategori(kunci)),
                  label: const SizedBox.shrink(),
                  selected: terpilih,
                  onSelected: (_) => pengontrol.ikon.value = kunci,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => TombolUtama(
              label: 'Simpan Kategori',
              ikon: Icons.check_rounded,
              pemuatan: pengontrol.menyimpan.value,
              onDitekan: () async {
                final berhasil = await pengontrol.tambah(
                  jenis: jenis,
                  nama: pengontrol.namaController.text,
                  ikonKunci: pengontrol.ikon.value ?? kunciIkon.first,
                );
                if (!berhasil) return;
                Get.back();
                tampilkanSnackbarDompetku(
                  jenis: JenisSnackbar.sukses,
                  judul: 'Berhasil',
                  pesan:
                      'Kategori ${pengontrol.namaController.text.trim()} ditambahkan.',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}