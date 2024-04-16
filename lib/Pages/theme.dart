import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  primaryColor: Colors.lightGreen[800],
  hintColor: Colors.grey[550],
  textTheme: TextTheme(
    displayLarge: TextStyle(color: Colors.grey[400], fontSize: 30, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: Colors.grey[400], fontSize: 18, fontWeight: FontWeight.w400),
    bodyLarge: TextStyle(color: Colors.grey[800], fontSize: 16),
    bodyMedium: TextStyle(color: Colors.grey[700], fontSize: 16),
    labelLarge: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.grey[850],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[850],
    iconTheme: IconThemeData(color: Colors.grey[300]),
  ),
  primaryColor: const Color.fromRGBO(94, 39, 176, 1.0),
  hintColor: Colors.grey[800],
  textTheme: TextTheme(
    displayLarge: TextStyle(color: Colors.grey[400], fontSize: 30, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: Colors.grey[400], fontSize: 18, fontWeight: FontWeight.w400),
    bodyLarge: TextStyle(color: Colors.grey[500], fontSize: 16),
    bodyMedium: TextStyle(color: Colors.grey[400], fontSize: 16),
    labelLarge: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0), fontWeight: FontWeight.bold, fontSize: 16),
  ),
);