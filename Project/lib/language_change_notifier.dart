import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeNotifier extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  set currentLanguage(String newLanguage) {
    _currentLanguage = newLanguage;
    notifyListeners();
    _saveLanguage(newLanguage);
  }

  LanguageChangeNotifier() {
    _loadLanguage();
  }

  _saveLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }

  _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'en';
    notifyListeners();
  }
}
