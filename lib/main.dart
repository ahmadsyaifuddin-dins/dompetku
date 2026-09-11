import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rive/rive.dart';

import 'komponen/pemuatan/pemuatan_spinkit.dart';
import 'app/app.dart';
import 'app/dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SplashDompetku());
}

/// Layar sementara saat dependensi disiapkan, lalu beralih ke aplikasi.
class SplashDompetku extends StatefulWidget {
  const SplashDompetku({super.key});

  @override
  State<SplashDompetku> createState() => _SplashDompetkuState();
}

class _SplashDompetkuState extends State<SplashDompetku> {
  @override
  void initState() {
    super.initState();
    _siapkan();
  }

  Future<void> _siapkan() async {
    await dotenv.load();
    await initializeDateFormatting('id_ID', null);
    try {
      await RiveNative.init();
    } catch (_) {
      // Rive hanya untuk ikon animasi dialog lib pihak ketiga;
      // kegagalan inisialisasi tidak boleh menghalangi aplikasi.
    }
    await Dependensi.inisialisasi();
    if (!mounted) return;
    runApp(const AplikasiDompetKu());
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PemuatanStartup(judul: 'DompetKu'),
    );
  }
}