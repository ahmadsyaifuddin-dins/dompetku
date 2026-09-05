import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../komponen/masukan/masukan_nominal.dart';
import '../../komponen/masukan/pilih_tanggal.dart';
import '../../komponen/snackbar/snackbar_dompetku.dart';
import '../../komponen/tombol/tombol_utama.dart';
import 'form_transaksi_controller.dart';

class HalamanFormTransaksi extends StatelessWidget {
  const HalamanFormTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    final argumen = Get.arguments;
    final sedangMengedit = argumen is TransaksiData ? argumen : null;
    final jenis = sedangMengedit?.jenis ?? (argumen as JenisTransaksi);
    final pengontrol = Get.put(FormTransaksiController(
      jenis: jenis,
      repositoriTransaksi: Get.find(),
      repositoriAkunDana: Get.find(),
      repositoriKategori: Get.find(),
      sedangMengedit: sedangMengedit,
    ));
    final judul =
        jenis == JenisTransaksi.pemasukan ? 'Pemasukan' : 'Pengeluaran';
    final labelSimpan = sedangMengedit == null ? 'Simpan $judul' : 'Perbarui';
    final sesuaiJenis = jenis == JenisTransaksi.pemasukan
        ? Icons.add_circle_rounded
        : Icons.remove_circle_rounded;

    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            MasukanNominal(controller: pengontrol.nominalController),
            const SizedBox(height: 20),
            Obx(
              () => DropdownButtonFormField<String>(
                key: ValueKey(pengontrol.akunId.value),
                initialValue: pengontrol.akunId.value,
                decoration: const InputDecoration(
                  labelText: 'Akun Dana',
                  prefixIcon: Icon(Icons.account_balance_wallet_rounded),
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
                    : (nilai) => pengontrol.akunId.value = nilai,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => DropdownButtonFormField<String>(
                key: ValueKey(pengontrol.kategoriId.value),
                initialValue: pengontrol.kategoriId.value,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(
                    sesuaiJenis,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                items: pengontrol.opsiKategori
                    .map(
                      (kategori) => DropdownMenuItem(
                        value: kategori.id,
                        child: Text(kategori.nama),
                      ),
                    )
                    .toList(),
                onChanged: pengontrol.opsiKategori.isEmpty
                    ? null
                    : (nilai) => pengontrol.kategoriId.value = nilai,
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
                label: labelSimpan,
                ikon: Icons.check_rounded,
                pemuatan: pengontrol.menyimpan.value,
                onDitekan: () async {
                  final berhasil = await pengontrol.simpan();
                  if (!berhasil) return;
                  tampilkanSnackbarDompetku(
                    jenis: JenisSnackbar.sukses,
                    judul: 'Berhasil',
                    pesan: sedangMengedit == null
                        ? '$judul sebesar '
                            '${pengontrol.nominalController.text} tersimpan.'
                        : '$judul diperbarui.',
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