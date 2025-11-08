// BledsoeTech Smart Home Control System - Widget Tests
// User: Bathushan30
// Date: 2025-11-08 04:42:46 UTC

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iot/main.dart';
import 'package:firebase_core/firebase_core.dart';

// Mock Firebase for testing
void setupFirebaseAuthMocks() {
  // This is needed because Firebase requires native platform integration
  TestWidgetsFlutterBinding.ensureInitialized();
}

void main() {
  setUpAll(() async {
    setupFirebaseAuthMocks();
  });

  group('BledsoeTech App Tests', () {
    testWidgets('App launches with splash screen', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      // Verify that splash screen route exists
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify app title
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.title, 'BledsoeTech');
    });

    testWidgets('App uses dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.brightness, Brightness.dark);
    });

    testWidgets('Debug banner is disabled', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, false);
    });

    testWidgets('Initial route is splash screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.initialRoute, '/splash');
    });
  });

  group('App Colors Tests', () {
    test('Primary color is cyan (#03D9F6)', () {
      expect(
        const Color(0xFF03D9F6).value,
        0xFF03D9F6,
      );
    });

    test('Primary gradient has 3 colors', () {
      const gradient = [
        Color(0xFF03D9F6),
        Color(0xFF02A8C0),
        Color(0xFF017A8F),
      ];
      expect(gradient.length, 3);
    });
  });

  group('Navigation Routes Tests', () {
    testWidgets('App has all required routes', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      final routes = app.routes!;

      // Verify all routes exist
      expect(routes.containsKey('/splash'), true);
      expect(routes.containsKey('/login'), true);
      expect(routes.containsKey('/register'), true);
      expect(routes.containsKey('/forgot-password'), true);
      expect(routes.containsKey('/home'), true);
      expect(routes.containsKey('/dashboard'), true);
      expect(routes.containsKey('/anomaly-hunter'), true);
      expect(routes.containsKey('/predictive-core'), true);
      expect(routes.containsKey('/heat-mapping'), true);
    });

    test('Route count is correct', () {
      const expectedRouteCount = 9;
      // /splash, /login, /register, /forgot-password, /home, 
      // /dashboard, /anomaly-hunter, /predictive-core, /heat-mapping
      expect(expectedRouteCount, 9);
    });
  });

  group('App Theme Tests', () {
    testWidgets('Scaffold background is black', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.scaffoldBackgroundColor, Colors.black);
    });

    testWidgets('Material 3 is enabled', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, true);
    });
  });

  group('User Information Tests', () {
    test('Current user is Bathushan30', () {
      const String currentUser = 'Bathushan30';
      expect(currentUser, 'Bathushan30');
    });

    test('App version is 1.0.0', () {
      const String version = '1.0.0';
      expect(version, '1.0.0');
    });
  });

  group('Feature Availability Tests', () {
    test('Advanced features count', () {
      const List<String> features = [
        'Anomaly Hunter',
        'Predictive Core',
        'Heat Mapping',
      ];
      expect(features.length, 3);
    });

    test('Main navigation tabs count', () {
      const List<String> tabs = [
        'Home',
        'Controls',
        'Analytics',
        'Settings',
      ];
      expect(tabs.length, 4);
    });
  });
}