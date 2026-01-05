import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ma_app_test/screens/planning_screen.dart';

void main() {
  testWidgets(
    'Planning screen shows non-connected placeholder when no Firebase',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlanningScreen()));

      // In test environment Firebase is not initialized, the screen should show 'Non connecté'
      expect(find.text('Non connecté'), findsOneWidget);
    },
  );
}
