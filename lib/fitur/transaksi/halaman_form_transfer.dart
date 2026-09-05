import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../komponen/masukan/masukan_nominal.dart';
import '../../komponen/masukan/pilih_tanggal.dart';
import '../../komponen/snackbar/snackbar_dompetku.dart';
import '../../komponen/tombol/tombol_utama.dart';
import 'form_transfer_controller.dart';

class HalamanFormTransfer extends StatelessWidget {
  const HalamanFormTransfer({super.key});

  @override
  Widget build(BuildContext context) {
    final pengontrol = Get.put(FormTransferController(
      repositoriTransfer: Get.find(),
      repositoriAkunDana: Get.find(),
    ));

    return Scaffold(
      appBar: AppBar(title: const Text('Transfer')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            MasukanNominal(controller: pengontrol.nominalController),
            const SizedBox(height: 20),
            Obx(
              () => DropdownButtonFormField<String>(
                key: ValueKey(pengontrol.akunAsalId.value),
                initialValue: pengontrol.akunAsalId.value,
                decoration: const InputDecoration(
                  labelText: 'Dari Akun',
                  prefixIcon: Icon(Icons.south_east_rounded),
                ),
                items: pengontrol.opsiAkun
                    .map(
                      (akun) => DropdownMenuItem(
                        value: akun.id,
                        child: Text(akun.nama),
                      ),
                    )
                    .toList(),
                onChanged: pengontrol.opsiAkun.isEmpty
                    ? null
                    : (nilai) => pengontrol.akunAsalId.value = nilai,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => DropdownButtonFormField<String>(
                key: ValueKey(pengontrol.akunTujuanId.value),
                initialValue: pengontrol.akunTujuanId.value,
                decoration: const InputDecoration(
                  labelText: 'Ke Akun',
                  prefixIcon: Icon(Icons.north_west_rounded),
                ),
                items: pengontrol.opsiAkun
                    .map(
                      (akun) => DropdownMenuItem(
                        value: akun.id,
                        child: Text(akun.nama),
                      ),
                    )
                    .toList(),
                onChanged: pengontrol.opsiAkun.isEmpty
                    ? null
                    : (nilai) => pengontrol.akunTujuanId.value = nilai,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => PilihTanggal(
                tanggal: pengontrol.tanggal.value,
                onBerubah: (tanggal) => pengontrol.tanggal.value = tanggal,
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
                label: 'Simpan Transfer',
                ikon: Icons.swap_horiz_rounded,
                pemuatan: pengontrol.menyimpan.value,
                onDitekan: () async {
                  final berhasil = await pengontrol.simpan();
                  if (!berhasil) return;
                  tampilkanSnackbarDompetku(
                    jenis: JenisSnackbar.sukses,
                    judul: 'Berhasil',
                    pesan: 'Transfer sebesar '
                        '${pengontrol.nominalController.text} tersimpan.',
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