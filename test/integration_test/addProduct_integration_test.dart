import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:register/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AddProduct Integration Test', () {
    testWidgets('Add product flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 15));

      print('Login page loaded');

      expect(find.byKey(Key('login_username_field')), findsOneWidget);
      expect(find.byKey(Key('login_password_field')), findsOneWidget);
      expect(find.byKey(Key('login_button')), findsOneWidget);

      await tester.enterText(find.byKey(Key('login_username_field')), 'test@example.com');
      await tester.pump();
      await tester.enterText(find.byKey(Key('login_password_field')), '@Password123/');
      await tester.pump();
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle(Duration(seconds: 10));

      print('Login button tapped');

      expect(find.byKey(Key('navigate_to_add_product_button')), findsOneWidget, reason: 'Navigate button not found');
      await tester.tap(find.byKey(Key('navigate_to_add_product_button')));
      await tester.pumpAndSettle(Duration(seconds: 10));

      print('Navigated to Add Product page');

      expect(find.text('Add Product'), findsOneWidget);
      expect(find.byKey(Key('product_name_field')), findsOneWidget);
      expect(find.byKey(Key('product_description_field')), findsOneWidget);
      expect(find.byKey(Key('image_picker_button')), findsOneWidget);
      expect(find.byKey(Key('category_selector')), findsOneWidget);
      expect(find.byKey(Key('submit_product_button')), findsOneWidget);

    });
  });
}
