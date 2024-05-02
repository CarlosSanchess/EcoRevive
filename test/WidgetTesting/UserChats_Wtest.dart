import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:register/Pages/UserChats.dart';
import 'package:register/import.dart';

void main() {

  setupFirebaseAuthMocks();

  setUpAll(() async {
    MockFirebaseStorage();
    await Firebase.initializeApp();
  });

  testWidgets('UserChats Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: UserChats(),
    ));

  });
}
