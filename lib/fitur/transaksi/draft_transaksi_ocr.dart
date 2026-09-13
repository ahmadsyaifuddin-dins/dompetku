import '../../data/model/enum_dompetku.dart';
import '../../core/utils/format_rupiah.dart';

/// Draft hasil OCR yang belum menjadi transaksi final.
class DraftTransaksiOCR {
  final JenisTransaksi jenis;
  final int nominal;
  final DateTime tanggal;
  final String? merchant;
  final String? metode;
  final String? akunDanaId;
  final String? kategoriId;
  final String? catatan;
  final String teksMentah;

  const DraftTransaksiOCR({
    required this.jenis,
    required this.nominal,
    required this.tanggal,
    this.merchant,
    this.metode,
    this.akunDanaId,
    this.kategoriId,
    this.catatan,
    required this.teksMentah,
  });
}

/// Titik masuk OCR -> parser -> draft.
///
/// Mengenali teks berformat "Kunci: Nilai" (struktur keluar Dompetku) maupun
/// teks mentah hasil mesin OCR, misal tangkapan layar notifikasi bank atau
/// e-wallet. Nilai hasil OCR hanya menjadi sampel; pengguna mengoreksinya di
/// layar tinjauan (PRD 15.4).
///
/// Mengembalikan null bila nominal tidak terbaca dan [wajibNominal] aktif.
/// Atur [wajibNominal] ke false untuk tetap melengkapi di layar tinjauan.
DraftTransaksiOCR? ekstrakDraftDariTeks(
  String teks, {
  bool wajibNominal = true,
}) {
  final baris = teks
      .split('\n')
      .map((b) => b.trim())
      .where((b) => b.isNotEmpty)
      .toList();

  var jenis = _tebakJenisDariTeks(teks);
  var nominal = 0;
  var tanggal = DateTime.now();
  String? merchant;
  String? metode;
  String? catatan;

  for (final token in baris) {
    final pisah = token.indexOf(':');
    if (pisah < 0) continue;
    final kunci = token.substring(0, pisah).trim().toLowerCase();
    final nilai = token.substring(pisah + 1).trim();
    if (nilai.isEmpty) continue;

    switch (kunci) {
      case 'jenis':
        jenis = nilai.toLowerCase().contains('pemasukan')
            ? JenisTransaksi.pemasukan
            : JenisTransaksi.pengeluaran;
        break;
      case 'nominal':
        nominal = parseNominalInput(nilai) ?? nominal;
        break;
      case 'tanggal' || 'tgl' || 'date' || 'waktu':
        tanggal = _parseTanggal(nilai) ?? tanggal;
        break;
      case 'merchant' || 'penerima' || 'toko' || 'nama':
        merchant = nilai;
        break;
      case 'metode' || 'metode pembayaran' || 'akun':
        metode = nilai;
        break;
      case 'catatan' || 'keterangan':
        catatan = nilai;
        break;
    }
  }

  if (nominal <= 0) nominal = parseNominalOCR(teks) ?? 0;
  merchant ??= _cariMerchantDariTeks(baris);
  metode ??= _cariMetodeDariTeks(baris);
  final dariTanggal = _cariTanggalDariTeks(baris);
  if (dariTanggal != null) tanggal = dariTanggal;

  if (wajibNominal && nominal <= 0) return null;

  return DraftTransaksiOCR(
    jenis: jenis,
    nominal: nominal,
    tanggal: tanggal,
    merchant: merchant,
    metode: metode,
    catatan: catatan,
    teksMentah: teks.trim(),
  );
}

/// Draft dari teks mentah yang selalu dibuat (nominal boleh kosong) agar
/// pengguna tetap bisa melengkapi di layar tinjauan, mis. saat teks terbaca
/// namun nominalnya tidak terdeteksi.
DraftTransaksiOCR buatDraftTeksMentah(String teks) {
  final terurai = ekstrakDraftDariTeks(teks, wajibNominal: false);
  if (terurai != null) return terurai;
  return DraftTransaksiOCR(
    jenis: JenisTransaksi.pengeluaran,
    nominal: 0,
    tanggal: DateTime.now(),
    teksMentah: teks.trim(),
  );
}

/// Baca nominal dari teks mentah, misal "Rp 75.000,00", "Rp75.000",
/// atau "1.500.000" (berpenanda titik ribuan).
///
/// Mengabaikan komponen desimal koma karena rupiah tidak memakai pecahan sen
/// di aplikasi ini. Saat ada beberapa nilai (misal saldo + total), nilai pada
/// baris berisi "total/bayar/transfer/nominal" lebih diutamakan, lalu nilai
/// terbesar.
int? parseNominalOCR(String teks) {
  var kandidat = _kumpulkanNominal(teks, harusBerawalanRp: true);
  if (kandidat.isEmpty) {
    kandidat = _kumpulkanNominal(teks, harusBerawalanRp: false);
  }
  if (kandidat.isEmpty) return null;

  final tanpaSaldo =
      kandidat.where((k) => !k.nilaiTerkontekstual.toLowerCase().contains('saldo')).toList();
  final kumpulan = tanpaSaldo.isEmpty ? kandidat : tanpaSaldo;

  final denganKunci = kumpulan.where((k) {
    final b = k.nilaiTerkontekstual.toLowerCase();
    return b.contains('total') ||
        b.contains('bayar') ||
        b.contains('transfer') ||
        b.contains('nominal') ||
        b.contains('transaksi') ||
        b.contains('nilai') ||
        b.contains('jumlah');
  }).toList();
  final pilihan = denganKunci.isEmpty ? kumpulan : denganKunci;

  pilihan.sort((a, b) => b.nilai.compareTo(a.nilai));
  return pilihan.first.nilai;
}

class _KandidatNominal {
  final int nilai;
  final String nilaiTerkontekstual;

  _KandidatNominal(this.nilai, this.nilaiTerkontekstual);
}

List<_KandidatNominal> _kumpulkanNominal(
  String teks, {
  required bool harusBerawalanRp,
}) {
  final hasil = <_KandidatNominal>[];
  final pola = harusBerawalanRp
      ? RegExp(r'Rp[.\s:]*([\d.,]+)', caseSensitive: false)
      : RegExp(r'(?<!\d)\d{1,3}(\.\d{3})+(?!\d)');

  final baris = teks.split('\n');
  for (var i = 0; i < baris.length; i++) {
    final barisIni = baris[i];
    for (final cocok in pola.allMatches(barisIni)) {
      final nilai = _bersihkanNominal(
        harusBerawalanRp ? cocok.group(1)! : cocok.group(0)!,
      );
      if (nilai == null || nilai <= 0) continue;
      final sebelumnya = i > 0 ? '${baris[i - 1]} ' : '';
      final berikutnya =
          i + 1 < baris.length ? ' ${baris[i + 1]}' : '';
      hasil.add(_KandidatNominal(nilai, '$sebelumnya$barisIni$berikutnya'));
    }
  }
  return hasil;
}

int? _bersihkanNominal(String teks) {
  final tanpaDesimal = teks.replaceAll(RegExp(r',\d{2}$'), '');
  final angka = tanpaDesimal.replaceAll(RegExp(r'[^0-9]'), '');
  if (angka.isEmpty) return null;
  final nilai = int.tryParse(angka);
  return nilai == null ? null : (nilai > 0 ? nilai : null);
}

JenisTransaksi _tebakJenisDariTeks(String teks) {
  final t = teks.toLowerCase();
  const kataMasuk = [
    'pemasukan',
    'penerimaan',
    'diterima',
    'menerima',
    'masuk',
    'credited',
    'saldo masuk',
    'incoming',
    'top up',
    '+ rp',
    '+rp',
  ];
  const kataKeluar = [
    'pengeluaran',
    'pembayaran',
    'dibayar',
    'pembayaran ke',
    'terkirim',
    'keluar',
    'debit',
    'transfer keluar',
    'outgoing',
    'purchase',
    'payment',
  ];
  for (final kata in kataMasuk) {
    if (t.contains(kata)) return JenisTransaksi.pemasukan;
  }
  for (final kata in kataKeluar) {
    if (t.contains(kata)) return JenisTransaksi.pengeluaran;
  }
  return JenisTransaksi.pengeluaran;
}

const _kataMerchantGarisSama = [
  'dari',
];

const _kataMerchantBarisBerikut = [
  'kepada',
  'penerima',
  'bayar ke',
  'pembayaran ke',
  'untuk',
  'merchant',
  'nama toko',
  'toko',
  'ke',
];

String? _cariMerchantDariTeks(List<String> baris) {
  for (var i = 0; i < baris.length; i++) {
    final token = baris[i];
    final pisah = token.indexOf(':');
    if (pisah >= 0) {
      final kunci = token.substring(0, pisah).trim().toLowerCase();
      if (kunci == 'merchant' ||
          kunci == 'penerima' ||
          kunci == 'toko' ||
          kunci == 'nama' ||
          kunci == 'nama toko' ||
          kunci == 'penjual') {
        final nilai = _bersihkanNama(token.substring(pisah + 1));
        if (nilai != null) return nilai;
      }
    }

    for (final kata in _kataMerchantBarisBerikut) {
      final mengandung = RegExp('(?:$kata)\\b', caseSensitive: false)
          .hasMatch(token);
      if (!mengandung) continue;
      final nilai = _nilaiSetelahKata(token, kata);
      if (nilai != null) return nilai;
      if (i + 1 < baris.length) {
        final nilaiBarisBerikut = _nilaiBarisBerikut(baris, i + 1);
        if (nilaiBarisBerikut != null) return nilaiBarisBerikut;
      }
    }

    for (final kata in _kataMerchantGarisSama) {
      final nilai = _nilaiSetelahKata(token, kata);
      if (nilai != null) return nilai;
    }
  }
  return null;
}

String? _nilaiSetelahKata(String token, String kata) {
  final pola = RegExp('(?:$kata)\\b', caseSensitive: false);
  final cocok = pola.firstMatch(token);
  if (cocok == null) return null;
  final sisa = token.substring(cocok.end).trimLeft();
  if (sisa.isEmpty) return null;
  final bersih = _bersihkanNama(sisa);
  if (bersih == null || bersih.toLowerCase().contains('rp')) return null;
  return _bukanKandidatMerchant(bawah: bersih) ? bersih : null;
}

String? _nilaiBarisBerikut(List<String> baris, int indeks) {
  final berikut = baris[indeks];
  if (_bukanKandidatMerchant(bawah: berikut)) return null;
  return _bersihkanNama(berikut);
}

bool _bukanKandidatMerchant({required String bawah}) {
  final token = bawah.trim();
  if (token.isEmpty) return false;
  if (token.toLowerCase().contains('tanggal') ||
      token.toLowerCase().contains('waktu') ||
      token.toLowerCase().contains('jam')) {
    return false;
  }
  if (token.toLowerCase().contains('rp')) return false;
  final bersih = token.replaceAll(RegExp(r'[^0-9.,\s]'), '');
  if (bersih.trim().isEmpty) return true;
  if (RegExp(r'^\s*\d[\d.,]*\s*$').hasMatch(token)) return false;
  return true;
}

String? _bersihkanNama(String nilai) {
  final bersih = nilai
      .replaceAll(RegExp(r'^[:,.|\s]+|[:,.|\s]+$'), '')
      .trim();
  if (bersih.isEmpty) return null;
  return bersih;
}

const _kataMetode = [
  'gopay',
  'ovo',
  'dana',
  'shopeepay',
  'linkaja',
  'seabank',
  'sea bank',
  'bca',
  'bni',
  'bri',
  'mandiri',
  'permata',
  'jenius',
  'bsi',
  'maybank',
  'digibank',
];

String? _cariMetodeDariTeks(List<String> baris) {
  for (final token in baris) {
    for (final nama in _kataMetode) {
      final pola = RegExp('(?:$nama)\\b', caseSensitive: false);
      final cocok = pola.firstMatch(token);
      if (cocok != null) {
        final nilai = _bersihkanNama(cocok.group(0)!);
        if (nilai != null) return nilai;
      }
    }
  }
  return null;
}

const _kataTanggal = [
  'tanggal',
  'tgl',
  'date',
  'waktu',
];

DateTime? _cariTanggalDariTeks(List<String> baris) {
  DateTime? hasil;
  for (final token in baris) {
    final pisah = token.indexOf(':');
    if (pisah >= 0) {
      final kunci = token.substring(0, pisah).trim().toLowerCase();
      final nilai = token.substring(pisah + 1).trim();
      for (final kata in _kataTanggal) {
        if (kunci == kata || kunci.contains(kata)) {
          final t = _parseTanggal(nilai.isEmpty ? token : nilai);
          if (t != null) return t;
        }
      }
    }
    hasil ??= _parseTanggal(token);
  }
  return hasil;
}

const _namaBulan = [
  'januari',
  'februari',
  'maret',
  'april',
  'mei',
  'juni',
  'juli',
  'agustus',
  'september',
  'oktober',
  'november',
  'desember',
];

DateTime? _parseTanggal(String nilai) {
  final iso = DateTime.tryParse(nilai);
  if (iso != null) return iso;

  final bagian = nilai
      .split(RegExp(r'[/\\\-\. ]+'))
      .where((b) => b.isNotEmpty)
      .toList();
  if (bagian.length < 3) return null;
  return _tanggalDariBagian(bagian.sublist(0, 3));
}

DateTime? _tanggalDariBagian(List<String> b) {
  final tahun = int.tryParse(b[2]);
  final tanggal = int.tryParse(b[0]);
  if (tahun == null || tanggal == null) return null;
  final bulanAngka = int.tryParse(b[1]);
  if (bulanAngka != null && bulanAngka >= 1 && bulanAngka <= 12) {
    return DateTime(tahun, bulanAngka, tanggal);
  }
  final indeksBulan = _namaBulan.indexOf(b[1].toLowerCase());
  if (indeksBulan >= 0) return DateTime(tahun, indeksBulan + 1, tanggal);
  return null;
}

/// Contoh teks yang bentuknya mirip struktur keluar pada PRD 15.3.
const String contohTeksOCR = '''
Jenis: Pengeluaran
Nominal: Rp75.000
Tanggal: 5 September 2026
Merchant: Contoh Merchant
Metode: SeaBank
Catatan: Pembayaran
''';

DraftTransaksiOCR buatDraftContoh() {
  final draft = ekstrakDraftDariTeks(contohTeksOCR);
  assert(draft != null, 'contoh OCR harus selalu terbaca');
  return draft!;
}