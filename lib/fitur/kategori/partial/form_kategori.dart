import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/database/database.dart';
import '../../../data/model/enum_dompetku.dart';
import '../../../core/constants/ikon_map.dart';
import '../../../komponen/snackbar/snackbar_dompetku.dart';
import '../../../komponen/tombol/tombol_utama.dart';
import '../kategori_controller.dart';

class FormKategori extends StatelessWidget {
  final KategoriController pengontrol;
  final KategoriData? sedangMengedit;

  const FormKategori({
    super.key,
    required this.pengontrol,
    this.sedangMengedit,
  });

  @override
  Widget build(BuildContext context) {
    final jenis = sedangMengedit?.jenis ?? pengontrol.tab.value;
    final kunciIkon = jenis == JenisTransaksi.pemasukan
        ? kunciIkonKategoriPemasukan
        : kunciIkonKategoriPengeluaran;
    final mengubah = sedangMengedit != null;
    final judul = mengubah ? 'Ubah Kategori' : 'Tambah Kategori';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Indikator drag / pegangan (opsional, untuk konsistensi UI)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                judul,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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
                  label: mengubah ? 'Perbarui Kategori' : 'Simpan Kategori',
                  ikon: Icons.check_rounded,
                  pemuatan: pengontrol.menyimpan.value,
                  onDitekan: () async {
                    final berhasil = mengubah
                        ? await pengontrol.perbarui(
                            sedangMengedit!,
                            nama: pengontrol.namaController.text,
                            ikonKunci: pengontrol.ikon.value ?? kunciIkon.first,
                          )
                        : await pengontrol.tambah(
                            jenis: jenis,
                            nama: pengontrol.namaController.text,
                            ikonKunci: pengontrol.ikon.value ?? kunciIkon.first,
                          );
                    if (!berhasil) return;
                    Get.back();
                    tampilkanSnackbarDompetku(
                      jenis: JenisSnackbar.sukses,
                      judul: 'Berhasil',
                      pesan: mengubah
                          ? 'Kategori diperbarui.'
                          : 'Kategori ${pengontrol.namaController.text.trim()} ditambahkan.',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}