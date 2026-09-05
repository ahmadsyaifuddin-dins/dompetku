enum JenisAkun { cash, bank, ewallet }

extension NamaJenisAkun on JenisAkun {
  String get nama {
    switch (this) {
      case JenisAkun.cash:
        return 'cash';
      case JenisAkun.bank:
        return 'bank';
      case JenisAkun.ewallet:
        return 'ewallet';
    }
  }
}

enum JenisTransaksi { pemasukan, pengeluaran }

extension NamaJenisTransaksi on JenisTransaksi {
  String get nama {
    switch (this) {
      case JenisTransaksi.pemasukan:
        return 'pemasukan';
      case JenisTransaksi.pengeluaran:
        return 'pengeluaran';
    }
  }
}

enum JenisRiwayat { pinjaman, tambahan, pembayaran }

extension NamaJenisRiwayat on JenisRiwayat {
  String get nama {
    switch (this) {
      case JenisRiwayat.pinjaman:
        return 'pinjaman';
      case JenisRiwayat.tambahan:
        return 'tambahan';
      case JenisRiwayat.pembayaran:
        return 'pembayaran';
    }
  }
}

enum ModeTema { system, terang, gelap }

extension NamaModeTema on ModeTema {
  String get nama {
    switch (this) {
      case ModeTema.system:
        return 'system';
      case ModeTema.terang:
        return 'terang';
      case ModeTema.gelap:
        return 'gelap';
    }
  }
}