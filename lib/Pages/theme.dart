import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  primaryColor: Colors.lightGreen[800],
  hintColor: Color.fromRGBO(85, 139, 47, 1),
  textTheme: TextTheme(
    headline1: TextStyle(color: Colors.grey[400], fontSize: 30, fontWeight: FontWeight.bold),
    headline2: TextStyle(color: Colors.grey[400], fontSize: 18, fontWeight: FontWeight.w400),
    bodyText1: TextStyle(color: Colors.grey[800], fontSize: 16),
    bodyText2: TextStyle(color: Colors.grey[700], fontSize: 16),
    button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.grey[850], // Darker background color
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[850], // Darker app bar background color
    iconTheme: IconThemeData(color: Colors.grey[300]), // Grey icon color
  ),
  primaryColor: Color.fromRGBO(94, 39, 176, 1.0),
  hintColor: Color.fromRGBO(94, 39, 176, 1.0),
  textTheme: TextTheme(
    headline1: TextStyle(color: Colors.grey[400], fontSize: 30, fontWeight: FontWeight.bold),
    headline2: TextStyle(color: Colors.grey[400], fontSize: 18, fontWeight: FontWeight.w400),
    bodyText1: TextStyle(color: Colors.grey[500], fontSize: 16), // Darker grey text color
    bodyText2: TextStyle(color: Colors.grey[400], fontSize: 16), // Lighter text color
    button: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0), fontWeight: FontWeight.bold, fontSize: 16), // Purple text color for buttons
  ),
);


