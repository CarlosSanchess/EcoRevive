import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:register/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AddProduct Integration Test', () {
    testWidgets('Add product flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      try {
        await tester.enterText(find.byKey(Key('login_username_field')), 'test@example.com');
        await tester.enterText(find.byKey(Key('login_password_field')), '@Password123/');
        await tester.tap(find.byKey(Key('login_button')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(Key('navigate_to_add_product_button')));
        await tester.pumpAndSettle();

        expect(find.text('Add Product'), findsOneWidget);

        await tester.enterText(find.byKey(Key('product_name_field')), 'Test Product');
        await tester.pump();

        await tester.enterText(find.byKey(Key('product_description_field')), 'Test Description');
        await tester.pump();

        await tester.tap(find.byKey(Key('image_picker_button')));
        await tester.pump();

        await tester.tap(find.byKey(Key('category_selector')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Electronics').last);
        await tester.pump();

        await tester.tap(find.byKey(Key('submit_product_button')));
        await tester.pumpAndSettle();

        expect(find.text('Product added successfully'), findsOneWidget);
      } catch (error) {
        print('Test failed with error: $error');
        rethrow; // Rethrow the error to fail the test
      }
    });
  });
}
