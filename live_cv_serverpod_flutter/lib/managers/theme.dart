import 'package:flutter/material.dart';

///Class responsible for providing the theme to other widgets in the app.
class ThemeManager extends ChangeNotifier {
  ///Field to store current theme mode, initialised to light.
  ThemeMode themeMode = ThemeMode.light;

  ///Getter responsible for determining whether theme is dark.
  bool get isDarkMode => themeMode == ThemeMode.dark;

  ///Method responsible for toggling the theme.
  void toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
