import 'package:flutter/material.dart';

import '../../inti/utilitas/format_tanggal.dart';

class PilihTanggal extends StatelessWidget {
  final DateTime tanggal;
  final ValueChanged<DateTime> onBerubah;

  const PilihTanggal({
    super.key,
    required this.tanggal,
    required this.onBerubah,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _pilihTanggal(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Tanggal',
          prefixIcon: Icon(Icons.event_rounded),
        ),
        child: Text(
          formatTanggal(tanggal),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final dipilih = await showDatePicker(
      context: context,
      initialDate: tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Pilih Tanggal',
    );
    if (dipilih != null) onBerubah(dipilih);
  }
}