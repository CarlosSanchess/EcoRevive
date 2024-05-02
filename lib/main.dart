import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register/Auth/Auth.dart';
import 'package:register/Pages/Home.dart';
import 'package:register/Pages/Login.dart';
import 'package:register/Pages/ModeratorHome.dart';
import 'package:register/Pages/theme_provider.dart';
import 'package:register/firebase_options.dart';
import 'package:register/Controllers/NotificationController.dart';
import 'package:flutter_driver/driver_extension.dart';


void main() async {
  enableFlutterDriverExtension();
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
  final PushNotificationService _pushNotificationService = PushNotificationService();
  Future<void> _initPushNotifications() async {
    await _pushNotificationService.initialise();
  }

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
              ? (auth.currentUser?.email == "mod@gmail.com" ? const ModeratorHome() : const Home())
              : const Login()
          : const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
