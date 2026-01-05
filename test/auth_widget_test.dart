import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ma_app_test/screens/login_screen.dart';

void main() {
  testWidgets('Login screen shows fields and buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // email + password
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text("S'inscrire"), findsOneWidget);
  });
}
