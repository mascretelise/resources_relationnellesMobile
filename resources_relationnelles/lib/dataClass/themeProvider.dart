import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  ThemeData _theme =
      ThemeData(brightness: Brightness.dark); //Valeur par défaut de l'app

  ThemeData get theme => _theme;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    //Méthode de changement de thème
    _theme = _theme.brightness == Brightness.light
        ? ThemeData(brightness: Brightness.dark)
        : ThemeData(brightness: Brightness.light);
    _isDarkMode = !_isDarkMode;
    notifyListeners(); //applique le thème
  }

  void setThemeFromBool(bool isDark) {
    _isDarkMode = isDark;
    _theme = isDark
        ? ThemeData(brightness: Brightness.dark)
        : ThemeData(brightness: Brightness.light);
    notifyListeners(); // Triggers UI rebuild
  }
}
