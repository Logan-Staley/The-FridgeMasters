import 'package:flutter/material.dart';

<<<<<<< HEAD
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
=======

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  ThemeData get themeData => _themeData;

  
  setTheme(ThemeData themeData) {
    _themeData = themeData;
>>>>>>> parent of 5f11636 (commit)
    notifyListeners();
  }


}