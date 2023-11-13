import 'package:flutter/material.dart';

// Assuming you have separate Dart files for each language like strings_en.dart
import 'localization/strings_en.dart';
import 'localization/strings_es.dart';
import 'localization/strings_fr.dart';

class LanguageChangeNotifier extends ChangeNotifier {
  String _currentLanguage = 'en';
  Map<String, String> _localizedStrings = stringsEn; // Default to English

  Map<String, String> get localizedStrings => _localizedStrings;

  void changeLanguage(String newLanguage) {
    if (newLanguage != _currentLanguage) {
      _currentLanguage = newLanguage;
      if (newLanguage == 'en') {
        _localizedStrings = stringsEn;
      } else if (newLanguage == 'es') {
        _localizedStrings = stringsEs;
      } else if (newLanguage == 'fr') {
        _localizedStrings = stringsFr;
      }
      notifyListeners();
    }
  }
}
