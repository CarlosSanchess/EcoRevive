import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:register/Pages/Home.dart';
import 'package:register/Pages/addProduct.dart';
import 'package:register/firebase_options.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // MUdar para Android??
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoRevive',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home:  addProduct(),
    );
  }
}