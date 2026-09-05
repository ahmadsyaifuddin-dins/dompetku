import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../data/repositori/repositori_akun_dana.dart';
import '../../inti/utilitas/format_rupiah.dart';
import '../../inti/validasi/validasi_transaksi.dart';
import '../../komponen/masukan/masukan_nominal.dart';
import '../../komponen/masukan/pilih_tanggal.dart';
import '../../komponen/snackbar/snackbar_dompetku.dart';
import '../../komponen/tombol/tombol_utama.dart';
import 'detail_piutang_controller.dart';

/// Lembar untuk mencatat pinjaman tambahan atau pembayaran piutang.
Future<void> bukaLembarAksiPiutang(
  BuildContext context,
  DetailPiutangController pengontrol, {
  required JenisRiwayat jenis,
  required PiutangData piutang,
  int praisiNominal = 0,
}) async {
  final nominalController = TextEditingController(
    text: praisiNominal > 0 ? praisiNominal.toString() : '',
  );
  final catatanController = TextEditingController();
  final akunId = RxnString();
  final tanggal = DateTime.now().obs;
  final mengirim = false.obs;
  final opsiAkun = <AkunDanaData>[].obs;
  var sudahDispose = false;

  StreamSubscription<List<AkunDanaData>>? langgananAkun;

  final aksi = jenis == JenisRiwayat.pinjaman ? 'Pinjaman' : 'Pembayaran';

  void dispose() {
    if (sudahDispose) return;
    sudahDispose = true;
    langgananAkun?.cancel();
    nominalController.dispose();
    catatanController.dispose();
  }

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      langgananAkun = Get.find<RepositoriAkunDana>()
          .pantauSemuaAktif()
          .listen((data) {
        opsiAkun.value = data;
        if (akunId.value == null && data.isNotEmpty) {
          akunId.value = data.first.id;
        }
      });

      return GetBuilder<DetailPiutangController>(
        init: pengontrol,
        builder: (_) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 0,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Catat $aksi',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      piutang.nama,
                      style: TextStyle(
                        color: Theme.of(sheetContext)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MasukanNominal(controller: nominalController),
                  const SizedBox(height: 16),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      key: ValueKey(akunId.value),
                      initialValue: akunId.value,
                      decoration: const InputDecoration(
                        labelText: 'Akun Dana',
                        prefixIcon:
                            Icon(Icons.account_balance_wallet_rounded),
                      ),
                      items: opsiAkun
                          .map(
                            (akun) => DropdownMenuItem(
                              value: akun.id,
                              child: Text(akun.nama),
                            ),
                          )
                          .toList(),
                      onChanged: opsiAkun.isEmpty
                          ? null
                          : (nilai) => akunId.value = nilai,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => PilihTanggal(
                      tanggal: tanggal.value,
                      onBerubah: (nilai) => tanggal.value = nilai,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: catatanController,
                    maxLines: 2,
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
                          color: Theme.of(sheetContext).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }),
                  Obx(
                    () => TombolUtama(
                      label: 'Simpan $aksi',
                      ikon: Icons.check_rounded,
                      pemuatan: mengirim.value,
                      onDitekan: () async {
                        final nominal = int.tryParse(nominalController.text);
                        final galatNominal = validasiNominal(nominal);
                        if (galatNominal != null) {
                          pengontrol.galat.value = galatNominal;
                          return;
                        }
                        if (akunId.value == null) {
                          pengontrol.galat.value = 'Pilih akun dana.';
                          return;
                        }
                        mengirim.value = true;
                        final berhasil = await pengontrol.catat(
                          jenis: jenis,
                          akunDanaId: akunId.value!,
                          nominal: nominal!,
                          tanggal: tanggal.value,
                          catatan: catatanController.text.trim(),
                        );
                        mengirim.value = false;
                        if (!berhasil) return;
                        tampilkanSnackbarDompetku(
                          jenis: JenisSnackbar.sukses,
                          judul: 'Berhasil',
                          pesan: '$aksi ${formatRupiah(nominal)} dicatat.',
                        );
                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).whenComplete(dispose);
}