import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'log_debug.dart';

/// Tombol kecil untuk membuka/menutup konsol debug di sudut layar.
class SaklarPanelDebug extends StatelessWidget {
  final ValueNotifier<bool> terbuka;

  const SaklarPanelDebug({super.key, required this.terbuka});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return ValueListenableBuilder<bool>(
      valueListenable: terbuka,
      builder: (context, buka, _) {
        return FloatingActionButton.small(
          heroTag: 'saklar-debug',
          tooltip: 'Konsol debug',
          backgroundColor: buka ? warna.errorContainer : warna.surfaceContainer,
          foregroundColor: buka ? warna.onErrorContainer : warna.primary,
          onPressed: () => terbuka.value = !buka,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                buka ? Icons.close_rounded : Icons.bug_report_rounded,
                size: 20,
              ),
              if (!buka && DebugLog.saya.jumlahGalat > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: warna.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${DebugLog.saya.jumlahGalat}',
                      style: TextStyle(
                        color: warna.onError,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Panel konsol debug yang menampilkan [DebugLog] secara langsung,
/// lengkap dengan tombol salin dan gulir otomatis ke entri terbaru.
class PanelDebug extends StatefulWidget {
  final ValueNotifier<bool> terbuka;

  const PanelDebug({super.key, required this.terbuka});

  @override
  State<PanelDebug> createState() => _PanelDebugState();
}

class _PanelDebugState extends State<PanelDebug> {
  final _gulir = ScrollController();

  @override
  void dispose() {
    _gulir.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return ValueListenableBuilder<bool>(
      valueListenable: widget.terbuka,
      builder: (context, buka, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: !buka
              ? const SizedBox.shrink()
              : Material(
                  key: const ValueKey('panel-debug'),
                  color: const Color(0xF20B1220),
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: max(
                        260,
                        min(340, MediaQuery.sizeOf(context).height * 0.55),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        top: BorderSide(
                          color: warna.outlineVariant.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _barisJudul(warna),
                        const Divider(height: 1),
                        Expanded(child: _gulirLog()),
                        _barisBawah(warna),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _barisJudul(ColorScheme warna) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Icon(Icons.bug_report_rounded, size: 18, color: warna.primary),
          const SizedBox(width: 8),
          Text(
            'Debug Console',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: DebugLog.saya.aliran,
              builder: (context, entri, _) {
                final jumlahGalat = DebugLog.saya.jumlahGalat;
                return Text(
                  '${entri.length} baris · $jumlahGalat gagal',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: jumlahGalat > 0
                        ? Colors.redAccent
                        : Colors.white38,
                    fontSize: 11,
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Salin log',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.copy_rounded, size: 18),
            color: Colors.white70,
            onPressed: _salinLog,
          ),
          IconButton(
            tooltip: 'Bersihkan',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.delete_sweep_rounded, size: 18),
            color: Colors.white70,
            onPressed: () => DebugLog.saya.bersihkan(),
          ),
          IconButton(
            tooltip: 'Tutup',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.expand_more_rounded, size: 20),
            color: Colors.white70,
            onPressed: () => widget.terbuka.value = false,
          ),
        ],
      ),
    );
  }

  Widget _gulirLog() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: DebugLog.saya.aliran,
      builder: (context, entri, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_gulir.hasClients && entri.isNotEmpty) {
            _gulir.jumpTo(_gulir.position.maxScrollExtent);
          }
        });
        return ListView.builder(
          controller: _gulir,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: entri.length,
          itemBuilder: (context, indeks) => _barisEntri(entri[indeks]),
        );
      },
    );
  }

  Widget _barisEntri(String baris) {
    final warna = _warnaEntri(baris);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        baris,
        style: TextStyle(
          color: warna,
          fontSize: 11.5,
          height: 1.35,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Color _warnaEntri(String baris) {
    if (baris.contains('✗')) return Colors.redAccent;
    if (baris.contains('⚠')) return Colors.orangeAccent;
    if (baris.contains('✓')) return Colors.lightGreenAccent;
    if (baris.contains('≡')) return const Color(0xFF90CAF9);
    return Colors.white70;
  }

  Widget _barisBawah(ColorScheme warna) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Row(
        children: [
          Icon(Icons.circle, size: 6, color: Colors.greenAccent),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'Live — peristiwa dicatat langsung',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Fonnte: ${_ringkasFonnte()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  String _ringkasFonnte() {
    try {
      final token = dotenv.env['FONNTE_TOKEN'] ?? '';
      final nomor = dotenv.env['WA_PENGEMBANG'] ?? '';
      final proxy = dotenv.env['FONNTE_PROXY_URL'] ?? '';
      final present = [token.isNotEmpty, nomor.isNotEmpty, proxy.isNotEmpty]
          .where((ada) => ada)
          .length;
      final target = _pakaiProxy
          ? 'via proxy'
          : 'langsung api.fonnte.com';
      return '$present/3 env · $target';
    } catch (_) {
      return 'env belum dimuat';
    }
  }

  bool get _pakaiProxy {
    try {
      final nilai = dotenv.env['FONNTE_PROXY_URL'] ?? '';
      return kIsWeb && nilai.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _salinLog() async {
    final teks = DebugLog.saya.entri.join('\n');
    await Clipboard.setData(ClipboardData(text: teks));
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Log debug disalin ke papan klip.'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}