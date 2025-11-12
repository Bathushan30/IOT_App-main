import 'package:flutter/material.dart';
import 'package:iot/screens/splash.dart';
import 'package:iot/screens/auth/login.dart';

import 'package:iot/screens/auth/register.dart';
import 'package:iot/features/anomaly_hunter/anomaly_hunter.dart';
import 'package:iot/features/predictive_core/predictive_core.dart';
import 'package:iot/features/heat_mapping/heat_mapping.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProHome IoT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF03D9F6),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF1A1A1A),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF03D9F6),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF03D9F6), width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A1A1A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade800, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF03D9F6), width: 2),
          ),
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/anomaly-hunter': (context) => const AnomalyHunter(),
        '/predictive-core': (context) => const PredictiveCore(),
        '/heat-mapping': (context) => const HeatMapping(),
        '/login': (context) => const LoginScreen(),

        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
