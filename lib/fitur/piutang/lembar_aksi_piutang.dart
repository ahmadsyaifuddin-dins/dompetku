import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/enum_dompetku.dart';
import '../../data/repositori/repositori_akun_dana.dart';
import '../../core/utils/format_rupiah.dart';
import '../../core/validation/validasi_transaksi.dart';
import '../../komponen/masukan/masukan_nominal.dart';
import '../../komponen/masukan/pilih_tanggal.dart';
import '../../komponen/tombol/tombol_utama.dart';
import 'detail_piutang_controller.dart';

/// Lembar untuk mencatat pinjaman tambahan atau pembayaran piutang.
/// Mengembalikan pesan sukses bila aksi berhasil, atau null bila dibatalkan.
Future<String?> bukaLembarAksiPiutang(
  BuildContext context,
  DetailPiutangController pengontrol, {
  required JenisRiwayat jenis,
  required PiutangData piutang,
  int praisiNominal = 0,
}) {
  return showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => _LembarAksiPiutang(
      pengontrol: pengontrol,
      jenis: jenis,
      piutang: piutang,
      praisiNominal: praisiNominal,
    ),
  );
}

class _LembarAksiPiutang extends StatefulWidget {
  final DetailPiutangController pengontrol;
  final JenisRiwayat jenis;
  final PiutangData piutang;
  final int praisiNominal;

  const _LembarAksiPiutang({
    required this.pengontrol,
    required this.jenis,
    required this.piutang,
    required this.praisiNominal,
  });

  @override
  State<_LembarAksiPiutang> createState() => _LembarAksiPiutangState();
}

class _LembarAksiPiutangState extends State<_LembarAksiPiutang> {
  late final TextEditingController nominalController;
  final catatanController = TextEditingController();
  StreamSubscription<List<AkunDanaData>>? langgananAkun;

  String? akunId;
  DateTime tanggal = DateTime.now();
  bool mengirim = false;
  List<AkunDanaData> opsiAkun = [];
  String? pesanGalat;

  String get aksi => widget.jenis == JenisRiwayat.pinjaman ? 'Pinjaman' : 'Pembayaran';

  @override
  void initState() {
    super.initState();
    nominalController = TextEditingController(
      text: widget.praisiNominal > 0 ? widget.praisiNominal.toString() : '',
    );

    // Memantau data langsung ke local state, lebih aman saat widget di-unmount
    langgananAkun = Get.find<RepositoriAkunDana>()
        .pantauSemuaAktif()
        .listen((data) {
      if (mounted) {
        setState(() {
          opsiAkun = data;
          if (akunId == null && data.isNotEmpty) {
            akunId = data.first.id;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    langgananAkun?.cancel();
    nominalController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warnaError = tema.colorScheme.error;
    final warnaTeksSub = tema.colorScheme.onSurfaceVariant;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 0,
        // MediaQuery aman digunakan di dalam StatefulWidget biasa
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
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
                widget.piutang.nama,
                style: TextStyle(color: warnaTeksSub),
              ),
            ),
            const SizedBox(height: 16),
            MasukanNominal(controller: nominalController),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: ValueKey(akunId),
              value: akunId,
              decoration: const InputDecoration(
                labelText: 'Akun Dana',
                prefixIcon: Icon(Icons.account_balance_wallet_rounded),
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
                  : (nilai) {
                      setState(() {
                        akunId = nilai;
                      });
                    },
            ),
            const SizedBox(height: 16),
            PilihTanggal(
              tanggal: tanggal,
              onBerubah: (nilai) {
                setState(() {
                  tanggal = nilai;
                });
              },
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
            if (pesanGalat != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  pesanGalat!,
                  style: TextStyle(
                    color: warnaError,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            TombolUtama(
              label: 'Simpan $aksi',
              ikon: Icons.check_rounded,
              pemuatan: mengirim,
              onDitekan: () async {
                final nominal = parseNominalInput(nominalController.text);
                final galatNominal = validasiNominal(nominal);
                
                if (galatNominal != null || nominal == null) {
                  setState(() => pesanGalat = galatNominal ?? 'Nominal harus lebih besar dari 0.');
                  return;
                }
                if (akunId == null) {
                  setState(() => pesanGalat = 'Pilih akun dana.');
                  return;
                }

                setState(() {
                  pesanGalat = null;
                  mengirim = true;
                });

                final berhasil = await widget.pengontrol.catat(
                  jenis: widget.jenis,
                  akunDanaId: akunId!,
                  nominal: nominal,
                  tanggal: tanggal,
                  catatan: catatanController.text.trim(),
                );

                if (berhasil) {
                  if (mounted) {
                    Navigator.pop(context, '$aksi ${formatRupiah(nominal)} dicatat.');
                  }
                } else {
                  if (mounted) {
                    setState(() {
                      mengirim = false;
                      pesanGalat = widget.pengontrol.galat.value ?? 'Terjadi kesalahan sistem.';
                    });
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}