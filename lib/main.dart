
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register/Pages/Login.dart';
import 'package:register/Pages/Profile.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:register/Pages/Home.dart';

import 'package:register/Pages/addProduct.dart';
import 'package:register/firebase_options.dart';

import 'Pages/theme.dart';
import 'Pages/theme_provider.dart'; // Import your theme_provider.dart file

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(lightTheme),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'EcoRevive',
      theme: themeProvider.getTheme(),
      home: ProfileScreen(),
    );
  }
}