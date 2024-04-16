import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:register/Pages/theme.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;

  ThemeProvider() {
    _loadThemePreference();
  }

  ThemeData getTheme() => _themeData;

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }

  Future<void> setTheme(ThemeData theme) async {
    _themeData = theme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeData == darkTheme);
  }

  void toggleTheme() async {
    if (_themeData == lightTheme) {
      await setTheme(darkTheme);
    } else {
      await setTheme(lightTheme);
    }
  }
}
