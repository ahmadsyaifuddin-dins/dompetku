import 'package:flutter/material.dart';

const Map<String, IconData> ikonKategori = {
  'gaji': Icons.business_center_rounded,
  'uang_saku': Icons.monetization_on_rounded,
  'bonus': Icons.card_giftcard_rounded,
  'hadiah': Icons.redeem_rounded,
  'makanan': Icons.restaurant_rounded,
  'transportasi': Icons.directions_bus_rounded,
  'belanja': Icons.shopping_bag_rounded,
  'tagihan': Icons.receipt_rounded,
  'hiburan': Icons.sports_esports_rounded,
  'pendidikan': Icons.school_rounded,
  'kesehatan': Icons.medical_services_rounded,
  'lainnya': Icons.category_rounded,
  'layanan': Icons.miscellaneous_services_rounded,
};

IconData ikonUntukKategori(String? namaKunci) {
  return ikonKategori[namaKunci] ?? Icons.category_rounded;
}

const List<String> kunciIkonKategoriPemasukan = [
  'gaji',
  'uang_saku',
  'bonus',
  'hadiah',
];

const List<String> kunciIkonKategoriPengeluaran = [
  'makanan',
  'transportasi',
  'belanja',
  'tagihan',
  'hiburan',
  'pendidikan',
  'kesehatan',
  'layanan',
  'lainnya',
];

const Map<String, IconData> ikonAkunDana = {
  'cash': Icons.payments_rounded,
  'bank': Icons.account_balance_rounded,
  'ewallet': Icons.smartphone_rounded,
};

IconData ikonUntukAkunDana(String? namaKunci) {
  return ikonAkunDana[namaKunci] ?? Icons.account_balance_wallet_rounded;
}