import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register/Auth/Auth.dart';
import 'package:register/Pages/Home.dart';

import 'package:register/Pages/theme_provider.dart';
import 'package:register/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:register/Controllers/NotsController.dart';
import 'package:register/Controllers/NotificationService.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Pages/Login.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await _requestLocationPermission();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MultiProvider(
        providers: [
          Provider<NotificationService>(
            create: (context) => NotificationService(),
          ),
          Provider<FirebaseMessagingService>(
            create: (context) => FirebaseMessagingService(context.read<NotificationService>()),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

Future<void> _requestLocationPermission() async {
  PermissionStatus status = await Permission.location.request();

  if (status.isGranted) {
    // Permission granted
  } else if (status.isDenied) {
    // Permission denied
    print('Location permission denied');
  } else if (status.isPermanentlyDenied) {
    // Permission permanently denied, take the user to the settings
    openAppSettings();
  }
}

class MyApp extends StatelessWidget {
  Auth auth = Auth();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
