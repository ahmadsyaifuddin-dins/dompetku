import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/enum_dompetku.dart';
import '../../../komponen/masukan/masukan_nominal.dart';
import '../../../komponen/snackbar/snackbar_dompetku.dart';
import '../../../komponen/tombol/tombol_utama.dart';
import '../akun_dana_controller.dart';

class FormTambahAkun extends StatelessWidget {
  final AkunDanaController pengontrol;

  const FormTambahAkun({super.key, required this.pengontrol});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Memberikan background solid dan sudut melengkung
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Menjaga agar tidak menabrak status bar di atas
      child: SafeArea(
        child: SingleChildScrollView(
          // Padding dipindah ke SINI
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24, // Sedikit lebih lega di atas
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tambahkan garis kecil (drag handle) opsional di tengah atas
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
                'Tambah Akun Sumber Dana',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pengontrol.namaController,
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
                () => SegmentedButton<JenisAkun>(
                  segments: const [
                    ButtonSegment(
                      value: JenisAkun.cash,
                      label: Text('Tunai'),
                      icon: Icon(Icons.payments_rounded),
                    ),
                    ButtonSegment(
                      value: JenisAkun.bank,
                      label: Text('Bank'),
                      icon: Icon(Icons.account_balance_rounded),
                    ),
                    ButtonSegment(
                      value: JenisAkun.ewallet,
                      label: Text('E-Wallet'),
                      icon: Icon(Icons.smartphone_rounded),
                    ),
                  ],
                  selected: {pengontrol.jenis.value},
                  onSelectionChanged: (pilihan) {
                    pengontrol.jenis.value = pilihan.first;
                  },
                ),
              ),
              const SizedBox(height: 16),
              MasukanNominal(
                controller: pengontrol.saldoAwalController,
                autofocus: false,
              ),
              const SizedBox(height: 16),
              Obx(
                () => TombolUtama(
                  label: 'Simpan Akun',
                  ikon: Icons.check_rounded,
                  pemuatan: pengontrol.menyimpan.value,
                  onDitekan: () async {
                    final berhasil = await pengontrol.tambah(
                      nama: pengontrol.namaController.text,
                      jenis: pengontrol.jenis.value,
                      saldoAwal: pengontrol.saldoAwal,
                    );
                    if (!berhasil) return;
                    Get.back();
                    tampilkanSnackbarDompetku(
                      jenis: JenisSnackbar.sukses,
                      judul: 'Berhasil',
                      pesan:
                          'Akun ${pengontrol.namaController.text.trim()} ditambahkan.',
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