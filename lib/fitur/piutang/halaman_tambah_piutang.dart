import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/repositori/repositori_piutang.dart';
import '../../komponen/snackbar/snackbar_dompetku.dart';
import '../../komponen/tombol/tombol_utama.dart';
import 'form_piutang_controller.dart';

class HalamanTambahPiutang extends StatelessWidget {
  const HalamanTambahPiutang({super.key});

  @override
  Widget build(BuildContext context) {
    final sedangMengedit =
        Get.arguments is PiutangData ? Get.arguments as PiutangData : null;
    final pengontrol = Get.put(
      FormPiutangController(
        repositoriPiutang: Get.find<RepositoriPiutang>(),
        sedangMengedit: sedangMengedit,
      ),
    );
    final sedangEdit = sedangMengedit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(sedangEdit ? 'Ubah Piutang' : 'Tambah Piutang'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: pengontrol.namaController,
              textCapitalization: TextCapitalization.words,
              autofocus: !sedangEdit,
              decoration: const InputDecoration(
                labelText: 'Nama Orang',
                hintText: 'Misal: Andi',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pengontrol.catatanController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Catatan',
                hintText: 'Tulis catatan (opsional)',
                alignLabelWithHint: true,
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
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
            Obx(
              () => TombolUtama(
                label: sedangEdit ? 'Perbarui Piutang' : 'Simpan Piutang',
                ikon: Icons.check_rounded,
                pemuatan: pengontrol.menyimpan.value,
                onDitekan: () async {
                  final berhasil = await pengontrol.simpan();
                  if (!berhasil) return;
                  tampilkanSnackbarDompetku(
                    jenis: JenisSnackbar.sukses,
                    judul: 'Berhasil',
                    pesan: sedangEdit
                        ? 'Piutang diperbarui.'
                        : 'Piutang baru ditambahkan.',
                  );
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}