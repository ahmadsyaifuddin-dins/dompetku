import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/database/database.dart';
import '../../../komponen/snackbar/snackbar_dompetku.dart';
import '../../../komponen/tombol/tombol_utama.dart';
import '../akun_dana_controller.dart';

class FormEditNama extends StatelessWidget {
  final AkunDanaController pengontrol;
  final AkunDanaData akun;

  const FormEditNama({super.key, required this.pengontrol, required this.akun});

  @override
  Widget build(BuildContext context) {
    final namaController = TextEditingController(text: akun.nama);
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
              const Text(
                'Edit Nama Akun',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: namaController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nama Akun',
                  hintText: 'Contoh: SeaBank',
                  prefixIcon: Icon(Icons.edit_rounded),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => TombolUtama(
                  label: 'Simpan Nama',
                  ikon: Icons.check_rounded,
                  pemuatan: pengontrol.menyimpan.value,
                  onDitekan: () async {
                    final berhasil = await pengontrol.perbaruiNama(
                      akun,
                      namaController.text,
                    );
                    if (!berhasil) return;
                    Get.back();
                    tampilkanSnackbarDompetku(
                      jenis: JenisSnackbar.sukses,
                      judul: 'Berhasil',
                      pesan: 'Nama akun diubah menjadi '
                          '${namaController.text.trim()}.',
                    );
                  },
                ),
              ),
              Obx(() {
                final pesan = pengontrol.galat.value;
                if (pesan == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    pesan,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}