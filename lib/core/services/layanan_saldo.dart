import 'dart:async';

import 'package:get/get.dart';

import '../../data/database/database.dart';
import '../../data/model/ringkasan_entri.dart';
import '../../data/repositori/repositori_akun_dana.dart';
import '../../data/repositori/repositori_kategori.dart';
import '../../data/repositori/repositori_piutang.dart';
import '../../data/repositori/repositori_transaksi.dart';
import '../../data/repositori/repositori_transfer.dart';
import '../utilitas/gabung_entri_histori.dart';
import '../utilitas/hitung_saldo.dart';

class LayananSaldo extends GetxService {
  final RepositoriAkunDana repositoriAkun;
  final RepositoriKategori repositoriKategori;
  final RepositoriTransaksi repositoriTransaksi;
  final RepositoriTransfer repositoriTransfer;
  final RepositoriPiutang repositoriPiutang;

  final akun = <AkunDanaData>[].obs;
  final kategori = <KategoriData>[].obs;
  final transaksi = <TransaksiData>[].obs;
  final transfer = <TransferData>[].obs;
  final riwayatPiutang = <RiwayatPiutangData>[].obs;
  final saldoPerAkun = <String, int>{}.obs;
  final pemuatan = true.obs;

  StreamSubscription<List<AkunDanaData>>? _langgananAkun;
  StreamSubscription<List<KategoriData>>? _langgananKategori;
  StreamSubscription<List<TransaksiData>>? _langgananTransaksi;
  StreamSubscription<List<TransferData>>? _langgananTransfer;
  StreamSubscription<List<RiwayatPiutangData>>? _langgananRiwayatPiutang;

  LayananSaldo({
    required this.repositoriAkun,
    required this.repositoriKategori,
    required this.repositoriTransaksi,
    required this.repositoriTransfer,
    required this.repositoriPiutang,
  });

  int get totalSaldo {
    var total = 0;
    for (final a in akun) {
      total += saldoPerAkun[a.id] ?? 0;
    }
    return total;
  }

  Map<String, AkunDanaData> get petaAkun =>
      {for (final a in akun) a.id: a};

  Map<String, KategoriData> get petaKategori =>
      {for (final k in kategori) k.id: k};

  List<EntriHistori> get histori => gabungEntriHistori(
        akun: petaAkun,
        kategori: petaKategori,
        transaksi: transaksi,
        transfer: transfer,
      );

  void mulai() {
    _langgananAkun = repositoriAkun.pantauSemuaAktif().listen((data) {
      akun.value = data;
      _sinkronkanSaldo();
    });
    _langgananKategori = repositoriKategori.pantauSemua().listen((data) {
      kategori.value = data;
    });
    _langgananTransaksi = repositoriTransaksi.pantauSemua().listen((data) {
      transaksi.value = data;
      _sinkronkanSaldo();
    });
    _langgananTransfer = repositoriTransfer.pantauSemua().listen((data) {
      transfer.value = data;
      _sinkronkanSaldo();
    });
    _langgananRiwayatPiutang = repositoriPiutang
        .pantauSemuaRiwayat()
        .listen((data) {
      riwayatPiutang.value = data;
      _sinkronkanSaldo();
    });
  }

  void _sinkronkanSaldo() {
    final peta = <String, int>{};
    for (final a in akun) {
      peta[a.id] = hitungSaldoAkun(
        saldoAwal: a.saldoAwal,
        idAkun: a.id,
        transaksi: transaksi,
        transfer: transfer,
        riwayatPiutang: riwayatPiutang,
      );
    }
    saldoPerAkun.value = peta;
    pemuatan.value = false;
  }

  void muatUlang() {
    pemuatan.value = true;
    _langgananAkun?.cancel();
    _langgananKategori?.cancel();
    _langgananTransaksi?.cancel();
    _langgananTransfer?.cancel();
    _langgananRiwayatPiutang?.cancel();
    mulai();
  }

  @override
  void onClose() {
    _langgananAkun?.cancel();
    _langgananKategori?.cancel();
    _langgananTransaksi?.cancel();
    _langgananTransfer?.cancel();
    _langgananRiwayatPiutang?.cancel();
    super.onClose();
  }
}