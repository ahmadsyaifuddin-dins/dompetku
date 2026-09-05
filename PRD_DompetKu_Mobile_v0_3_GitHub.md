# PRD — DompetKu Mobile

> **Versi:** 0.3  
> **Platform:** Flutter Mobile  
> **Status:** Product Requirements Document  
> **Mode:** Offline-first  
> **State Management:** GetX  
> **Bahasa kode:** Bahasa Indonesia (snake_case untuk file/folder)

---

## Daftar Isi

- [1. Ringkasan Produk](#1-ringkasan-produk)
- [2. Tujuan Produk](#2-tujuan-produk)
- [3. Ruang Lingkup MVP](#3-ruang-lingkup-mvp)
- [4. Prinsip Produk](#4-prinsip-produk)
- [5. Fitur Utama](#5-fitur-utama)
  - [5.1 Dashboard](#51-dashboard)
  - [5.2 Pemasukan](#52-pemasukan)
  - [5.3 Pengeluaran](#53-pengeluaran)
  - [5.4 Transfer Antar Akun](#54-transfer-antar-akun)
  - [5.5 Piutang](#55-piutang)
  - [5.6 Baca Transaksi dari Gambar](#56-baca-transaksi-dari-gambar)
  - [5.7 Pengaturan](#57-pengaturan)
- [6. Akun Dana](#6-akun-dana)
- [7. Kategori](#7-kategori)
- [8. Aturan Bisnis dan Integritas Data](#8-aturan-bisnis-dan-integritas-data)
- [9. Arsitektur Aplikasi](#9-arsitektur-aplikasi)
- [10. Struktur Folder](#10-struktur-folder)
- [11. Model Data](#11-model-data)
- [12. State UI dan Feedback](#12-state-ui-dan-feedback)
- [13. Design System](#13-design-system)
- [14. Paket Flutter](#14-paket-flutter)
- [15. OCR dan Ekstraksi Data](#15-ocr-dan-ekstraksi-data)
- [16. Edge Cases](#16-edge-cases)
- [17. Keamanan dan Privasi](#17-keamanan-dan-privasi)
- [18. Testing](#18-testing)
- [19. Roadmap](#19-roadmap)
- [20. Keputusan Teknis yang Perlu Dikunci](#20-keputusan-teknis-yang-perlu-dikunci)
- [21. Acceptance Criteria MVP](#21-acceptance-criteria-mvp)

---

## 1. Ringkasan Produk

**DompetKu** adalah aplikasi mobile pengelolaan keuangan pribadi yang dikembangkan dari konsep **DinsWealth** versi web, tetapi dirancang ulang sebagai aplikasi Flutter yang dapat digunakan secara offline dan dapat dipasang oleh pengguna lain.

Fokus utama aplikasi:

- pencatatan pemasukan dan pengeluaran;
- pengelolaan beberapa sumber dana;
- transfer antar akun;
- pengelolaan piutang berbasis orang dan histori;
- dashboard keuangan;
- pembacaan transaksi dari screenshot, bukti transfer, struk, invoice, dan foto dokumen;
- dukungan Light Mode, Dark Mode, dan System;
- seluruh fungsi inti tetap berjalan tanpa koneksi internet.

---

## 2. Tujuan Produk

### Tujuan utama

Membuat aplikasi keuangan pribadi yang:

- cepat digunakan untuk mencatat transaksi;
- mudah dipahami oleh pengguna non-teknis;
- memiliki histori transaksi yang jelas;
- mampu mengelola banyak akun dana;
- mampu mengelola piutang secara terstruktur;
- mengurangi input manual melalui OCR;
- menjaga integritas saldo;
- tetap dapat digunakan ketika offline.

### Target pengguna

- pengguna pribadi;
- mahasiswa;
- pekerja;
- pengguna yang memiliki beberapa akun bank/e-wallet;
- pengguna yang membutuhkan pencatatan piutang sederhana.

---

## 3. Ruang Lingkup MVP

### Termasuk

- [x] Flutter mobile
- [x] GetX untuk state management, dependency injection, dan routing
- [x] Offline-first
- [x] Database lokal
- [x] Light Mode
- [x] Dark Mode
- [x] System Theme
- [x] Dashboard
- [x] Pemasukan
- [x] Pengeluaran
- [x] Transfer antar akun
- [x] Histori transaksi
- [x] Akun dana
- [x] Kategori
- [x] Piutang
- [x] Cicilan/pembayaran piutang
- [x] OCR sebagai draft transaksi
- [x] Review dan koreksi hasil OCR
- [x] Feedback loading/success/error
- [ ] Cloud sync
- [ ] Multi-device sync
- [ ] Budgeting lanjutan
- [ ] Recurring transaction
- [ ] Reminder otomatis

---

## 4. Prinsip Produk

### 4.1 Offline-first

Fungsi inti tidak boleh bergantung pada koneksi internet.

```text
UI
 ↓
GetX Controller
 ↓
Repository
 ↓
Local Database
```

Jika OCR membutuhkan layanan cloud pada implementasi tertentu, pengguna harus diberi informasi dan persetujuan yang jelas sebelum data dikirim.

### 4.2 Saldo harus dapat dipercaya

Saldo tidak boleh berubah secara langsung karena hasil OCR.

Alur transaksi dari gambar:

```text
Gambar
  ↓
OCR
  ↓
Ekstraksi Data
  ↓
Draft Transaksi
  ↓
Review / Koreksi Pengguna
  ↓
Konfirmasi
  ↓
Transaksi Final
  ↓
Update Saldo
```

### 4.3 User tetap menjadi pengambil keputusan

OCR hanya membantu input.

> OCR tidak boleh langsung membuat transaksi final.

### 4.4 Reusable UI

Komponen seperti kartu, tombol, input, dialog, snackbar, skeleton, dan empty state harus dibuat reusable.

---

# 5. Fitur Utama

## 5.1 Dashboard

Dashboard menjadi halaman utama aplikasi.

Prioritas informasi:

1. saldo total;
2. arus uang;
3. akun dana;
4. analytics sederhana;
5. aktivitas terbaru.

Contoh komponen:

- kartu saldo total;
- pemasukan periode berjalan;
- pengeluaran periode berjalan;
- saldo per akun;
- grafik pemasukan vs pengeluaran;
- distribusi kategori pengeluaran;
- transaksi terbaru.

### Empty state

Jika belum ada transaksi:

```text
Belum ada transaksi

Mulai catat pemasukan atau pengeluaran
untuk melihat ringkasan keuanganmu.
```

---

## 5.2 Pemasukan

Pengguna dapat mencatat:

- nominal;
- kategori;
- akun dana tujuan;
- tanggal;
- catatan.

### Aturan

```text
saldo akun += nominal
```

Nominal harus lebih besar dari `0`.

---

## 5.3 Pengeluaran

Pengguna dapat mencatat:

- nominal;
- kategori;
- akun dana;
- tanggal;
- catatan.

### Aturan

```text
saldo akun -= nominal
```

Nominal harus lebih besar dari `0`.

---

## 5.4 Transfer Antar Akun

Transfer merupakan transaksi berbeda dari pemasukan/pengeluaran.

Contoh:

```text
SeaBank → Cash
Rp500.000
```

Dampak:

```text
Saldo SeaBank -= Rp500.000
Saldo Cash     += Rp500.000
```

Total saldo gabungan tetap sama.

### Validasi

- nominal > 0;
- akun asal wajib berbeda dari akun tujuan;
- akun asal harus tersedia;
- transaksi tidak boleh menyebabkan kondisi saldo yang tidak diizinkan oleh aturan aplikasi.

---

## 5.5 Piutang

Piutang menggunakan model **orang + histori kejadian**.

Contoh:

```text
Ibu
├── Pinjaman Rp500.000
├── Tambahan Rp200.000
└── Pembayaran Rp300.000

Sisa = Rp400.000
```

### Rumus

```text
Sisa Piutang =
Total Pinjaman
+ Total Tambahan
- Total Pembayaran
```

### Operasi

Pengguna dapat:

- membuat piutang baru;
- menambahkan pinjaman ke orang yang sama;
- melihat histori;
- mencatat pembayaran sebagian;
- mencatat pelunasan;
- melihat sisa otomatis.

### Dampak ke akun

Saat memberi pinjaman:

```text
saldo akun -= nominal
piutang += nominal
```

Saat menerima pembayaran:

```text
saldo akun += nominal
piutang -= nominal
```

### Validasi pembayaran

Secara default:

```text
pembayaran <= sisa piutang
```

Pembayaran yang melebihi sisa ditolak.

---

## 5.6 Baca Transaksi dari Gambar

Sumber gambar dapat berupa:

- screenshot;
- struk;
- invoice;
- bukti transfer;
- foto dokumen;
- bukti pembayaran.

### Pipeline

```text
Gambar
  ↓
OCR
  ↓
Ekstraksi
  ↓
Draft Transaksi
  ↓
Review/Koreksi
  ↓
Transaksi Final
```

### Field yang dapat diekstrak

- nominal;
- tanggal;
- waktu;
- merchant;
- pengirim;
- penerima;
- nomor referensi;
- deskripsi;
- metode pembayaran;
- jenis transaksi.

### Kondisi khusus

Jika nominal tidak terbaca:

```text
Nominal tidak ditemukan.
Silakan masukkan nominal secara manual.
```

Jika ditemukan beberapa nominal:

```text
Pilih nominal transaksi yang benar.
```

Jika tanggal meragukan:

```text
Tanggal perlu diverifikasi.
```

Jika gambar tidak dapat dibaca:

```text
Dokumen tidak dapat dibaca.
Coba gunakan gambar yang lebih jelas
atau masukkan transaksi secara manual.
```

---

## 5.7 Pengaturan

Menu pengaturan mencakup:

- tema;
- pengelolaan akun dana;
- pengelolaan kategori;
- data;
- backup/restore pada roadmap;
- export/import pada roadmap;
- informasi aplikasi.

### Tema

Pengguna dapat memilih:

```text
System
Light
Dark
```

---

# 6. Akun Dana

Aplikasi harus mendukung banyak sumber dana.

Jenis awal:

- Cash;
- Bank;
- E-wallet.

Contoh:

```text
Cash
SeaBank
GoPay
DANA
BCA
```

### Default akun

Pada instalasi pertama, aplikasi dapat membuat:

```text
SeaBank
```

sebagai akun default.

Namun:

> SeaBank bukan satu-satunya akun dan tidak boleh di-hardcode sebagai pilihan permanen.

Pengguna harus dapat:

- mengganti nama;
- menonaktifkan;
- membuat akun baru;
- mengelola akun sesuai kebutuhan.

Akun yang sudah digunakan oleh transaksi sebaiknya **dinonaktifkan**, bukan dihapus secara destruktif.

---

# 7. Kategori

Kategori digunakan untuk mengelompokkan transaksi.

Contoh:

### Pemasukan

- Gaji
- Uang saku
- Bonus
- Hadiah
- Lainnya

### Pengeluaran

- Makanan
- Transportasi
- Belanja
- Tagihan
- Hiburan
- Pendidikan
- Kesehatan
- Lainnya

Kategori yang sudah digunakan sebaiknya tidak dihapus secara destruktif. Gunakan status aktif/nonaktif.

---

# 8. Aturan Bisnis dan Integritas Data

| Aturan | Perilaku |
|---|---|
| Nominal | Harus `> 0` |
| Rupiah | Simpan sebagai integer |
| Pemasukan | Menambah saldo akun |
| Pengeluaran | Mengurangi saldo akun |
| Transfer | Mengurangi akun asal dan menambah akun tujuan |
| Total transfer | Tidak mengubah total saldo gabungan |
| Pinjaman | Mengurangi saldo dan menambah piutang |
| Pembayaran piutang | Menambah saldo dan mengurangi piutang |
| Pembayaran berlebih | Ditolak secara default |
| Transfer akun sama | Ditolak |
| Akun terpakai | Nonaktifkan, jangan hard delete |
| Kategori terpakai | Nonaktifkan, jangan hard delete |
| OCR | Tidak boleh langsung menjadi transaksi final |
| Edit transaksi | Saldo harus dihitung ulang dengan benar |
| Hapus transaksi | Saldo/dashboard harus diperbarui |
| Double submit | Harus dicegah |

---

# 9. Arsitektur Aplikasi

Arsitektur utama:

```text
┌─────────────────────────┐
│           UI            │
│        Flutter          │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│     GetX Controller     │
│ State + User Action     │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│       Repository        │
│ Business Data Access    │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│     Local Database      │
│      SQLite/Drift       │
└─────────────────────────┘
```

Service digunakan untuk kebutuhan lintas fitur, misalnya:

- OCR;
- pengaturan tema;
- konfigurasi aplikasi;
- helper lintas fitur.

### Prinsip dependency

```text
UI
 ↓
Controller
 ↓
Repository
 ↓
Data Source
```

UI tidak boleh mengakses database secara langsung.

Business logic penting seperti perhitungan saldo dan piutang harus dapat diuji tanpa widget Flutter.

---

# 10. Struktur Folder

Semua folder dan nama file menggunakan Bahasa Indonesia dan snake_case.

```text
lib/
├── utama/
│   ├── aplikasi.dart
│   ├── rute.dart
│   └── dependensi.dart
│
├── inti/
│   ├── tema/
│   │   ├── tema_terang.dart
│   │   ├── tema_gelap.dart
│   │   └── warna_tema.dart
│   ├── konstanta/
│   ├── utilitas/
│   ├── validasi/
│   └── layanan/
│
├── data/
│   ├── database/
│   ├── model/
│   ├── sumber_data/
│   └── repositori/
│
├── fitur/
│   ├── beranda/
│   ├── transaksi/
│   ├── piutang/
│   ├── akun_dana/
│   ├── kategori/
│   ├── baca_gambar/
│   └── pengaturan/
│
└── komponen/
    ├── tombol/
    ├── kartu/
    ├── masukan/
    ├── dialog/
    ├── snackbar/
    ├── pemuatan/
    ├── grafik/
    └── keadaan/
```

### Contoh penamaan

```text
halaman_detail_piutang.dart
HalamanDetailPiutang

transaksi_controller.dart
TransaksiController

layanan_baca_gambar.dart
LayananBacaGambar

kartu_saldo.dart
KartuSaldo

hitung_sisa_piutang()
```

Hindari:

```text
HomePage.dart
TransactionModel.dart
TransactionController.dart
ReceiptService.dart
```

---

# 11. Model Data

## 11.1 `akun_dana`

```text
id
nama
jenis
saldo_awal
ikon
aktif
dibuat_pada
diperbarui_pada
```

## 11.2 `kategori`

```text
id
nama
jenis
ikon
aktif
```

## 11.3 `transaksi`

```text
id
akun_dana_id
kategori_id
jenis
nominal
tanggal
catatan
dibuat_pada
diperbarui_pada
```

Jenis:

```text
pemasukan
pengeluaran
```

## 11.4 `transfer`

```text
id
akun_asal_id
akun_tujuan_id
nominal
tanggal
catatan
dibuat_pada
diperbarui_pada
```

## 11.5 `piutang`

```text
id
nama
catatan
dibuat_pada
diperbarui_pada
```

## 11.6 `riwayat_piutang`

```text
id
piutang_id
jenis
nominal
akun_dana_id
tanggal
catatan
dibuat_pada
```

Jenis:

```text
pinjaman
tambahan
pembayaran
```

## 11.7 `sumber_dokumen` — opsional

```text
id
lokasi
metadata
teks_ocr
waktu_baca
transaksi_id
```

---

# 12. State UI dan Feedback

Setiap fitur utama perlu mempertimbangkan state berikut:

```text
Initial
Loading
Processing
Saving
Success
Empty
Error
```

## Loading awal aplikasi

Gunakan **flutter_spinkit** untuk loading saat startup atau proses awal aplikasi.

## Loading data

Gunakan **shimmer** untuk skeleton:

- dashboard;
- daftar transaksi;
- piutang;
- akun;
- data lainnya.

Contoh:

```text
Loading:
[████████████████]
[██████████      ]
[██████████████  ]

Loaded:
Saldo Total
Rp5.000.000
```

Shimmer tidak boleh tampil terlalu lama setelah data sudah tersedia.

Jika data benar-benar kosong, tampilkan empty state.

Jika terjadi kegagalan, tampilkan error state + opsi retry.

## Feedback ringan

Gunakan **awesome_snackbar_content** untuk:

- sukses menyimpan;
- transaksi berhasil dibuat;
- warning;
- error ringan;
- informasi.

## Dialog penting

Gunakan **awesome_dialog** untuk:

- hapus transaksi;
- hapus/nonaktifkan data penting;
- konfirmasi pelunasan;
- konfirmasi backup/restore;
- aksi destruktif;
- warning kritis.

### Saving state

Saat menyimpan:

- tombol submit dinonaktifkan;
- cegah double submit;
- tampilkan indikator proses;
- setelah berhasil, tampilkan feedback;
- jika gagal, kembalikan tombol dan tampilkan error.

---

# 13. Design System

DompetKu harus memiliki design system terpusat.

## 13.1 Tema

Wajib mendukung:

```text
Light
Dark
System
```

## 13.2 Token

Gunakan token terpusat untuk:

- warna;
- typography;
- spacing;
- radius;
- elevation;
- iconography.

Jangan hardcode warna langsung di setiap widget.

Contoh konsep:

```text
warna_tema.dart
tema_terang.dart
tema_gelap.dart
```

Semua komponen harus membaca nilai dari `ThemeData`/token tema.

## 13.3 Gaya UI

Karakter UI:

- modern;
- minimal;
- bersih;
- whitespace cukup;
- rounded secukupnya;
- nyaman untuk satu tangan;
- tidak terlalu ramai.

## 13.4 Navigasi

Bottom navigation utama:

```text
Beranda
Transaksi
Piutang
Pengaturan
```

### Tombol tambah

FAB/action menu:

```text
Pemasukan
Pengeluaran
Transfer
Pinjaman
Baca dari Gambar
```

## 13.5 Pola layar

### Transaksi

Gunakan list/timeline, bukan tabel spreadsheet.

### Form transaksi

Nominal menjadi elemen paling menonjol.

### Piutang

Gunakan pola:

```text
Daftar Orang
    ↓
Detail Orang
    ↓
Histori Piutang
```

### Akun

Gunakan wallet/account cards.

### Grafik

Gunakan grafik sederhana:

- pemasukan vs pengeluaran;
- distribusi kategori.

---

# 14. Paket Flutter

| Paket | Peran | Area |
|---|---|---|
| `get` | State management, dependency injection, routing | Seluruh aplikasi |
| `flutter_spinkit` | Loading indicator | Startup / processing |
| `shimmer` | Skeleton loading | Dashboard, list, data |
| `awesome_snackbar_content` | Snackbar feedback | Success, warning, error, info |
| `awesome_dialog` | Dialog konfirmasi penting | Delete, settlement, destructive action |
| Paket database | Database lokal | Data |
| Paket OCR | Pembacaan teks gambar | Baca gambar |
| Paket image picker/camera | Mengambil gambar | Baca gambar |
| Paket chart | Grafik keuangan | Dashboard |

> Paket database, OCR, image picker, dan chart masih perlu dikunci berdasarkan kebutuhan implementasi dan kompatibilitas Flutter saat development dimulai.

### Matriks penggunaan UI feedback

| Kondisi | Komponen |
|---|---|
| Startup | `flutter_spinkit` |
| Load dashboard | `shimmer` |
| Load transaksi | `shimmer` |
| Load piutang | `shimmer` |
| Proses OCR | `flutter_spinkit` / processing state |
| Berhasil simpan | `awesome_snackbar_content` |
| Warning | `awesome_snackbar_content` |
| Error ringan | `awesome_snackbar_content` |
| Hapus data | `awesome_dialog` |
| Pelunasan | `awesome_dialog` |
| Restore data | `awesome_dialog` |
| Aksi destruktif | `awesome_dialog` |

---

# 15. OCR dan Ekstraksi Data

## 15.1 Tujuan

Mengurangi input manual saat pengguna memiliki bukti transaksi.

## 15.2 Input

```text
Screenshot
Foto struk
Invoice
Bukti transfer
Foto dokumen
```

## 15.3 Output OCR

OCR menghasilkan teks mentah.

```text
TEKS OCR
   ↓
PARSER / EKSTRAKTOR
   ↓
FIELD TERSTRUKTUR
```

Contoh draft:

```text
Jenis       : Pengeluaran
Nominal     : Rp75.000
Tanggal     : 2026-09-05
Merchant    : Contoh Merchant
Metode      : SeaBank
Catatan     : Pembayaran
```

## 15.4 Review

Sebelum final:

```text
┌──────────────────────────┐
│ Periksa transaksi        │
├──────────────────────────┤
│ Nominal                  │
│ Rp75.000                 │
│                          │
│ Tanggal                  │
│ 5 September 2026         │
│                          │
│ Akun                     │
│ SeaBank                  │
│                          │
│ [Koreksi] [Simpan]       │
└──────────────────────────┘
```

Jika pengguna mengoreksi, nilai koreksi pengguna menjadi sumber kebenaran final.

---

# 16. Edge Cases

## Transaksi

- [ ] Nominal `0` ditolak
- [ ] Nominal negatif ditolak
- [ ] Double submit dicegah
- [ ] Edit transaksi memperbarui saldo
- [ ] Hapus transaksi memperbarui saldo
- [ ] Gagal database menampilkan retry

## Transfer

- [ ] Nominal harus > 0
- [ ] Akun asal dan tujuan tidak boleh sama
- [ ] Akun asal harus tersedia
- [ ] Saldo gabungan tidak berubah

## Piutang

- [ ] Pembayaran > sisa ditolak
- [ ] Pembayaran sebagian didukung
- [ ] Pelunasan penuh didukung
- [ ] Tambahan pinjaman ke orang yang sama didukung
- [ ] Histori tetap tersimpan

## OCR

- [ ] Nominal tidak terbaca → input manual
- [ ] Banyak nominal → user memilih
- [ ] Tanggal meragukan → user verifikasi
- [ ] Gambar buram → error + manual
- [ ] OCR tidak pernah langsung mengubah saldo

## Data

- [ ] Akun terpakai tidak hard delete
- [ ] Kategori terpakai tidak hard delete
- [ ] Migrasi database harus versioned
- [ ] Restore harus meminta konfirmasi

## Tema

- [ ] Semua layar mendukung Light
- [ ] Semua layar mendukung Dark
- [ ] System mengikuti tema perangkat
- [ ] Tidak ada warna UI penting yang hanya terlihat baik di satu mode

---

# 17. Keamanan dan Privasi

Karena aplikasi menyimpan data finansial, integritas dan privasi harus menjadi perhatian utama.

## Database

- gunakan versioning/migration;
- validasi sebelum penyimpanan;
- hindari operasi destruktif tanpa konfirmasi;
- pertimbangkan backup/restore.

## OCR

Dokumen OCR dianggap sebagai data tidak tepercaya sampai diverifikasi pengguna.

Jangan:

```text
Gambar → OCR → langsung update saldo
```

Gunakan:

```text
Gambar
→ OCR
→ Draft
→ Review
→ Confirm
→ Final
```

## Privasi dokumen

Jika OCR menggunakan cloud:

- beri tahu pengguna;
- jangan upload diam-diam;
- pertimbangkan penghapusan file setelah diproses;
- jelaskan data apa yang dikirim.

---

# 18. Testing

Testing harus mencakup business logic dan UI.

## Unit test

Prioritas:

```text
hitung_sisa_piutang()
hitung_saldo_akun()
proses_transfer()
proses_pinjaman()
proses_pembayaran_piutang()
validasi_nominal()
```

### Contoh

```text
Pinjaman     = 500.000
Tambahan     = 200.000
Pembayaran   = 300.000
Sisa         = 400.000
```

## Test integritas saldo

Contoh:

```text
Saldo awal SeaBank = 1.000.000

Pengeluaran 100.000
→ 900.000

Transfer 200.000 ke Cash
→ SeaBank 700.000
→ Cash +200.000
```

Total gabungan harus tetap konsisten.

## Widget test

Minimal:

- dashboard;
- form transaksi;
- list transaksi;
- detail piutang;
- form pembayaran;
- akun;
- pengaturan tema;
- review OCR.

## Acceptance test

Pastikan alur utama dapat dilakukan end-to-end tanpa internet untuk fungsi offline.

---

# 19. Roadmap

## V0 — Foundation

- [ ] Flutter project
- [ ] GetX
- [ ] Routing
- [ ] Dependency injection
- [ ] Database lokal
- [ ] Design system
- [ ] Light/Dark/System
- [ ] UI states
- [ ] Reusable components

## V1 — Core Finance

- [ ] Akun dana
- [ ] Kategori
- [ ] Pemasukan
- [ ] Pengeluaran
- [ ] Transfer
- [ ] Histori transaksi

## V1.1 — Dashboard & Analytics

- [ ] Dashboard
- [ ] Filter transaksi
- [ ] Grafik pemasukan vs pengeluaran
- [ ] Distribusi kategori
- [ ] Recent activity

## V1.2 — Piutang

- [ ] Daftar orang
- [ ] Detail piutang
- [ ] Histori pinjaman
- [ ] Tambahan pinjaman
- [ ] Pembayaran sebagian
- [ ] Pelunasan
- [ ] Perhitungan sisa otomatis

## V1.3 — OCR

- [ ] Ambil gambar
- [ ] OCR
- [ ] Ekstraksi field
- [ ] Draft transaksi
- [ ] Review
- [ ] Koreksi
- [ ] Konfirmasi transaksi

## V1.4 — Data Management

- [ ] Backup
- [ ] Restore
- [ ] Export
- [ ] Import

## V2 — Advanced Personal Finance

- [ ] Budget
- [ ] Target tabungan
- [ ] Recurring transaction
- [ ] Reminder
- [ ] Insight keuangan

## V3 — Cloud

- [ ] Cloud sync
- [ ] Multi-device
- [ ] Account authentication
- [ ] Conflict resolution

---

# 20. Keputusan Teknis yang Perlu Dikunci

Sebelum implementasi penuh, keputusan berikut perlu dibuat:

### Database

- [ ] SQLite langsung
- [ ] Drift
- [ ] Strategi migration
- [ ] Integer ID vs UUID
- [ ] Soft delete strategy

### OCR

- [ ] Paket OCR
- [ ] Local OCR vs cloud OCR
- [ ] Bahasa yang didukung
- [ ] Parser format SeaBank
- [ ] Parser bank/e-wallet lain
- [ ] Strategi menyimpan metadata gambar
- [ ] Apakah PDF invoice masuk MVP

### UI

- [ ] Paket chart
- [ ] Design token final
- [ ] Icon set
- [ ] Komponen reusable final

### Quality

- [ ] Unit test coverage target
- [ ] Widget test target
- [ ] Integration test
- [ ] Strategi fixture/test data

---

# 21. Acceptance Criteria MVP

MVP dianggap berhasil jika:

- [ ] Pengguna dapat membuat akun dana.
- [ ] SeaBank tersedia sebagai akun default pada instalasi pertama, tetapi dapat diganti/dinonaktifkan.
- [ ] Pengguna dapat membuat pemasukan.
- [ ] Pengguna dapat membuat pengeluaran.
- [ ] Saldo akun berubah sesuai transaksi.
- [ ] Pengguna dapat transfer antar akun.
- [ ] Transfer tidak mengubah total saldo gabungan.
- [ ] Pengguna dapat membuat piutang.
- [ ] Pengguna dapat menambahkan pinjaman ke orang yang sama.
- [ ] Pengguna dapat mencatat pembayaran sebagian.
- [ ] Pengguna dapat melunasi piutang.
- [ ] Sisa piutang dihitung otomatis.
- [ ] Pembayaran melebihi sisa ditolak.
- [ ] Pengguna dapat membaca transaksi dari gambar.
- [ ] OCR menghasilkan draft, bukan transaksi final.
- [ ] Pengguna dapat mengoreksi hasil OCR.
- [ ] Transaksi baru hanya tersimpan setelah konfirmasi.
- [ ] Dashboard menampilkan kondisi keuangan berdasarkan data aktual.
- [ ] Loading state menggunakan komponen yang sesuai.
- [ ] Error state memiliki mekanisme retry jika relevan.
- [ ] Success/warning/error feedback tersedia.
- [ ] Aksi destruktif membutuhkan konfirmasi.
- [ ] Semua layar MVP mendukung Light Mode.
- [ ] Semua layar MVP mendukung Dark Mode.
- [ ] System Theme tersedia.
- [ ] Fungsi inti dapat digunakan tanpa internet.
- [ ] Business logic saldo dan piutang dapat diuji secara independen dari widget.

---

## Penutup

DompetKu diposisikan sebagai aplikasi **personal finance offline-first** yang sederhana tetapi memiliki fondasi data yang kuat.

Prioritas pengembangan:

```text
Integritas Data
      ↓
Core Finance
      ↓
UX
      ↓
Dashboard
      ↓
Piutang
      ↓
OCR
      ↓
Backup / Export
      ↓
Cloud Sync
```

Prinsip terpenting:

> **Lebih baik transaksi sedikit lebih lambat tetapi datanya benar, daripada otomatis tetapi saldo salah.**
