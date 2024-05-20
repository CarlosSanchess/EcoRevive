import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:register/main.dart' as app; // Replace with your actual app entry point

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AddProduct Integration Test', () {
    testWidgets('Add product flow', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to AddProduct screen
      // Assume there's a button to navigate to the AddProduct screen
      // Replace `navigate_to_add_product_button` with the actual key or finder
      await tester.tap(find.byKey(Key('navigate_to_add_product_button')));
      await tester.pumpAndSettle();

      // Verify we are on the AddProduct screen
      expect(find.text('Add Product'), findsOneWidget);

      // Enter product name
      await tester.enterText(find.byKey(Key('product_name_field')), 'Test Product');
      await tester.pump();

      // Enter product description
      await tester.enterText(find.byKey(Key('product_description_field')), 'Test Description');
      await tester.pump();

      // Simulate picking an image
      // This step is tricky because we can't actually pick an image in a test.
      // If you have a mechanism to mock or simulate the image picker, you should use it here.
      // For now, let's assume the image picker returns successfully.
      await tester.tap(find.byKey(Key('image_picker_button')));
      await tester.pump();

      // Select a category
      await tester.tap(find.byKey(Key('category_selector')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Electronics').last); // Replace with an actual category text
      await tester.pump();

      // Submit the product form
      await tester.tap(find.byKey(Key('submit_product_button')));
      await tester.pumpAndSettle();

      // Verify the product was added successfully
      // This depends on how your app responds to a successful submission
      expect(find.text('Product added successfully'), findsOneWidget);
    });
  });
}
