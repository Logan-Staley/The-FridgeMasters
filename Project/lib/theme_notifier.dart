import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  // Customize other light theme properties here
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.orange,
  // Customize other dark theme properties here
);

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;

  ThemeNotifier(this._themeData, this._isDarkMode);

  bool get isDarkMode => _isDarkMode;
  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }
}
