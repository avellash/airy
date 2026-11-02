
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/air_quality_viewmodel.dart';
import 'views/home_page.dart';

void main() {
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
