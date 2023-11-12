import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String currentLanguage = 'en';

  Map<String, Map<String, String>> localizedValues = {
    'en': {
      'title': 'Language',
      'content': 'Select your preferred language',
    },
    'es': {
      'title': 'Idioma',
      'content': 'Selecciona tu idioma preferido',
    },
    'fr': {
      'title': 'Langue',
      'content': 'Sélectionnez votre langue préférée',
    },
  };

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  _saveLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }

  _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentLanguage = prefs.getString('language') ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color appBarColor = theme.primaryColor;
    final Color activeColor = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizedValues[currentLanguage]!['title']!,
          style: theme.appBarTheme.titleTextStyle,
        ),
       // backgroundColor: theme.appBarTheme.backgroundColor,
       backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          Background(type: 'Background1'), // Consistent background
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizedValues[currentLanguage]!['content']!,
                  style: theme.textTheme.headline6,
                ),
                SizedBox(height: 20),
                _buildLanguageOption('en', 'English', activeColor),
                _buildLanguageOption('es', 'Español', activeColor),
                _buildLanguageOption('fr', 'Français', activeColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String value, String text, Color activeColor) {
    return RadioListTile<String>(
      title: Text(text, style: Theme.of(context).textTheme.subtitle1),
      value: value,
      groupValue: currentLanguage,
      onChanged: (String? selectedValue) {
        setState(() {
          currentLanguage = selectedValue!;
        });
        _saveLanguage(currentLanguage);
      },
      activeColor: activeColor,
    );
  }
}
