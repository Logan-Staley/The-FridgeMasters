import 'package:flutter/material.dart';


class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  ThemeData get themeData => _themeData;

  
  setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }


}