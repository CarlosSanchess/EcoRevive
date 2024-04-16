import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register/Auth/Auth.dart';
import 'package:register/Pages/Home.dart';
import 'package:register/Pages/Login.dart';
import 'package:register/Pages/theme_provider.dart';
import 'package:register/firebase_options.dart';
import 'Pages/theme.dart';
import 'Pages/theme_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  Auth auth = Auth();
  MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context){
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'EcoRevive',
      // Check if the theme is loaded, if not, show a loading indicator
      theme: themeProvider.isThemeLoaded
          ? themeProvider.getTheme()
          : ThemeData.light(),
      home: themeProvider.isThemeLoaded
          ? auth.currentUser != null
              ? const Home()
              : const Login()
          : const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
