import 'package:flutter/material.dart';

import '../../inti/utilitas/format_rupiah.dart';

class MasukanNominal extends StatefulWidget {
  final TextEditingController controller;
  final bool autofocus;

  const MasukanNominal({
    super.key,
    required this.controller,
    this.autofocus = true,
  });

  @override
  State<MasukanNominal> createState() => _MasukanNominalState();
}

class _MasukanNominalState extends State<MasukanNominal> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_formatSaatMengetik);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_formatSaatMengetik);
    super.dispose();
  }

  void _formatSaatMengetik() {
    final teks = formatNominalInput(widget.controller.text);
    if (teks == widget.controller.text && widget.controller.selection.isValid) {
      return;
    }
    widget.controller.value = TextEditingValue(
      text: teks,
      selection: TextSelection.collapsed(offset: teks.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return TextField(
      controller: widget.controller,
      autofocus: widget.autofocus,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: tema.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: tema.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: '0',
        hintStyle: tema.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: tema.colorScheme.outlineVariant,
        ),
        prefixText: 'Rp ',
        prefixStyle: tema.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: tema.colorScheme.onSurface,
        ),
        filled: true,
        fillColor: tema.colorScheme.surfaceContainerLowest,
      ),
    );
  }
}