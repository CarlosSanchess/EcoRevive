import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:register/Pages/theme.dart';

void main() {
  test('darkTheme should have the correct properties', () {
    expect(darkTheme.brightness, Brightness.dark);
    expect(darkTheme.scaffoldBackgroundColor, Colors.grey[850]);
    expect(darkTheme.appBarTheme.backgroundColor, Colors.grey[850]);
    expect(darkTheme.appBarTheme.iconTheme?.color, Colors.grey[300]);
    expect(darkTheme.primaryColor, Color.fromRGBO(94, 39, 176, 1.0));
    expect(darkTheme.hintColor, Colors.grey[800]);
    expect(darkTheme.textTheme.displayLarge?.color, Colors.grey[400]);
    expect(darkTheme.textTheme.displayLarge?.fontSize, 30);
    expect(darkTheme.textTheme.displayLarge?.fontWeight, FontWeight.bold);
    expect(darkTheme.textTheme.displayMedium?.color, Colors.grey[400]);
    expect(darkTheme.textTheme.displayMedium?.fontSize, 18);
    expect(darkTheme.textTheme.displayMedium?.fontWeight, FontWeight.w400);
    expect(darkTheme.textTheme.bodyLarge?.color, Colors.grey[500]);
    expect(darkTheme.textTheme.bodyLarge?.fontSize, 16);
    expect(darkTheme.textTheme.bodyMedium?.color, Colors.grey[400]);
    expect(darkTheme.textTheme.bodyMedium?.fontSize, 16);
    expect(darkTheme.textTheme.labelLarge?.color,
        Color.fromRGBO(255, 255, 255, 1.0));
    expect(darkTheme.textTheme.labelLarge?.fontWeight, FontWeight.bold);
    expect(darkTheme.textTheme.labelLarge?.fontSize, 16);
  });
}
