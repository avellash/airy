import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'viewmodels/air_quality_viewmodel.dart';
import 'views/home_page.dart';

Future<void> main() async {
  // Memastikan Flutter siap sebelum inisialisasi database.
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi database sesuai platform.
  if (kIsWeb) {
    // Untuk Chrome / Flutter Web.
    databaseFactory = databaseFactoryFfiWeb;
  } else if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    // Untuk aplikasi desktop.
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Menjalankan aplikasi.
  runApp(
    ChangeNotifierProvider(
      create: (context) => AirQualityViewModel(),
      child: const AiryApp(),
    ),
  );
}

class AiryApp extends StatelessWidget {
  const AiryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Airy - Kualitas Udara',

      // Tema utama aplikasi Airy.
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F6FF),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9277D8),
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F6FF),
          foregroundColor: Color(0xFF40345F),
          elevation: 0,
          centerTitle: false,
        ),

        fontFamily: 'Roboto',
      ),

      home: const HomePage(),
    );
  }
}
