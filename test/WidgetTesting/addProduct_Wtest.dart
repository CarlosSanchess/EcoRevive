import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:register/Pages/addProduct.dart';
import 'package:register/Pages/theme_provider.dart';

void main() {
  testWidgets(
    'Add Product Test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final themeProvider = Provider.of<ThemeProvider>(context);
                return AddProduct();
              },
            ),
          ),
        ),
      );

      expect(find.text('Add Image'), findsOneWidget);
    },
  );
}
