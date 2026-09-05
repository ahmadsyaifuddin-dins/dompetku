import '../../data/database/database.dart';

String? validasiNominal(int? nominal) {
  if (nominal == null || nominal <= 0) {
    return 'Nominal harus lebih besar dari 0.';
  }
  return null;
}

String? validasiTransfer({
  required AkunDanaData? akunAsal,
  required AkunDanaData? akunTujuan,
  required int? nominal,
}) {
  if (akunAsal == null) return 'Pilih akun asal.';
  if (akunTujuan == null) return 'Pilih akun tujuan.';

  final galatNominal = validasiNominal(nominal);
  if (galatNominal != null) return galatNominal;

  if (akunAsal.id == akunTujuan.id) {
    return 'Akun asal dan tujuan tidak boleh sama.';
  }
  if (!akunAsal.aktif) return 'Akun asal tidak aktif.';
  if (!akunTujuan.aktif) return 'Akun tujuan tidak aktif.';
  return null;
}