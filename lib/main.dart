import 'package:flutter/material.dart';
import 'package:iot/screens/auth/login.dart';
import 'package:iot/screens/auth/signup.dart'; // Changed from register.dart
import 'package:iot/utils/app_colors.dart';
import 'package:iot/rootnavigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BledsoeTech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignupScreen(), // Make sure this matches the class name in signup.dart
        '/home': (context) => const RootNavigator(),
      },
    );
  }
}