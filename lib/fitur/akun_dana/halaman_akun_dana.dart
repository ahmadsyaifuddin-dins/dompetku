import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../data/repositori/repositori_akun_dana.dart';
import '../../inti/konstanta/ikon_map.dart';
import '../../inti/layanan/layanan_saldo.dart';
import '../../inti/utilitas/format_rupiah.dart';
import '../../komponen/keadaan/keadaan_kosong.dart';
import '../../komponen/masukan/masukan_nominal.dart';
import '../../komponen/pemuatan/pemuatan_shimmer.dart';
import '../../komponen/snackbar/snackbar_dompetku.dart';
import '../../komponen/tombol/tombol_utama.dart';
import 'akun_dana_controller.dart';

class HalamanAkunDana extends StatelessWidget {
  const HalamanAkunDana({super.key});

  @override
  Widget build(BuildContext context) {
    final pengontrol = Get.put(
      AkunDanaController(
        repositori: Get.find<RepositoriAkunDana>(),
        layananSaldo: Get.find<LayananSaldo>(),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Akun Dana')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaFormTambah(context, pengontrol),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah'),
      ),
      body: Obx(() {
        if (Get.find<LayananSaldo>().pemuatan.value) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              KartuSkeletonTransaksi(),
              SizedBox(height: 12),
              KartuSkeletonTransaksi(),
            ],
          );
        }
        final aktif = pengontrol.akunAktif;
        final nonaktif = pengontrol.akunNonaktif;
        if (aktif.isEmpty && nonaktif.isEmpty) {
          return KeadaanKosong(
            ikon: Icons.account_balance_wallet_rounded,
            judul: 'Belum ada akun dana',
            pesan: 'Ketuk tombol Tambah untuk membuat akun pertamamu.',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...aktif.map(
              (akun) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _kartuAkun(context, pengontrol, akun),
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
                (akun) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _kartuAkun(context, pengontrol, akun),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _kartuAkun(
    BuildContext context,
    AkunDanaController pengontrol,
    AkunDanaData akun,
  ) {
    final tema = Theme.of(context);
    final saldo = pengontrol.saldoUntuk(akun.id) ?? akun.saldoAwal;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tema.colorScheme.surfaceContainerHighest,
          foregroundColor: tema.colorScheme.onSurfaceVariant,
          child: Icon(ikonUntukAkunDana(akun.jenis.nama)),
        ),
        title: Text(akun.nama),
        subtitle: Text(
          _labelJenis(akun.jenis) + (akun.aktif ? '' : ' • Tidak aktif'),
          style: TextStyle(
            color: akun.aktif
                ? null
                : tema.colorScheme.onSurfaceVariant,
            fontStyle: akun.aktif ? null : FontStyle.italic,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatRupiah(saldo),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () =>
                  _bukaMenuAkun(context, pengontrol, akun),
            ),
          ],
        ),
      ),
    );
  }

  String _labelJenis(JenisAkun jenis) {
    return switch (jenis) {
      JenisAkun.cash => 'Tunai',
      JenisAkun.bank => 'Bank',
      JenisAkun.ewallet => 'E-Wallet',
    };
  }

  void _bukaMenuAkun(
    BuildContext context,
    AkunDanaController pengontrol,
    AkunDanaData akun,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                akun.nama,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(formatRupiah(
                pengontrol.saldoUntuk(akun.id) ?? akun.saldoAwal,
              )),
            ),
            if (akun.aktif)
              ListTile(
                leading: const Icon(Icons.edit_rounded),
                title: const Text('Edit Nama'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _bukaEditNama(context, pengontrol, akun);
                },
              ),
            if (akun.aktif)
              ListTile(
                leading: Icon(
                  Icons.block_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Nonaktifkan Akun',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _konfirmasiNonaktifkan(context, pengontrol, akun);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _konfirmasiNonaktifkan(
    BuildContext context,
    AkunDanaController pengontrol,
    AkunDanaData akun,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: 'Nonaktifkan Akun?',
      desc: '${akun.nama} tidak akan muncul di daftar aktif, '
          'namun riwayat transaksinya tetap tersimpan.',
      btnCancelText: 'Batal',
      btnOkText: 'Nonaktifkan',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        final berhasil = await pengontrol.nonaktifkan(akun);
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
          pesan: 'Akun ${akun.nama} dinonaktifkan.',
        );
      },
    ).show();
  }

  void _bukaFormTambah(
    BuildContext context,
    AkunDanaController pengontrol,
  ) {
    Get.bottomSheet(
      isScrollControlled: true,
      _FormTambahAkun(pengontrol: pengontrol),
    );
  }

  void _bukaEditNama(
    BuildContext context,
    AkunDanaController pengontrol,
    AkunDanaData akun,
  ) {
    Get.bottomSheet(
      isScrollControlled: true,
      _FormEditNama(pengontrol: pengontrol, akun: akun),
    );
  }
}

class _FormEditNama extends StatelessWidget {
  final AkunDanaController pengontrol;
  final AkunDanaData akun;

  const _FormEditNama({required this.pengontrol, required this.akun});

  @override
  Widget build(BuildContext context) {
    final namaController = TextEditingController(text: akun.nama);
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
    );
  }
}

class _FormTambahAkun extends StatelessWidget {
  final AkunDanaController pengontrol;

  const _FormTambahAkun({required this.pengontrol});

  @override
  Widget build(BuildContext context) {
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
            'Tambah Akun Dana',
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
    );
  }
}