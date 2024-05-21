
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:register/Pages/Home.dart';
import 'package:register/import.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    MockFirebaseStorage();
    await Firebase.initializeApp();
  });

  testWidgets(
    'Home Page Test',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Home(),
      ));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      expect(find.text('Category'), findsOne);

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Row), findsWidgets);

      final List<String> categories = ['all', 'Computador', 'Telemóvel', 'Teclado', 'Rato', 'Outro'];
      for (final category in categories) {
        expect(find.text(category), findsOneWidget);
      }

      expect(find.byIcon(Icons.chat_bubble_rounded), findsOneWidget);
      expect(find.byIcon(Icons.add_box), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    },
  );
}


