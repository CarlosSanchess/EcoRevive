import 'package:flutter/material.dart';
import 'package:register/Auth/LoginOrRegister.dart';
import 'package:register/Pages/Entry.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoRevive',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const IntroPage(),
    );
  }
}