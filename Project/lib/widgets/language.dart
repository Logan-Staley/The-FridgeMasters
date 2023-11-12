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
      'content': 'Your content here',
    },
    'es': {
      'title': 'Idioma',
      'content': 'Tu contenido aquí',
    },
    'fr': {
      'title': 'Langue',
      'content': 'Votre contenu ici',
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
    return Scaffold(
      appBar: AppBar(
        title: Text(localizedValues[currentLanguage]!['title']!),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Background(type: 'Background1')), // For Background1
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(localizedValues[currentLanguage]!['content']!),
                SizedBox(height: 20),
                RadioListTile<String>(
                  title: const Text('English'),
                  value: 'en',
                  groupValue: currentLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      currentLanguage = value!;
                    });
                    _saveLanguage(currentLanguage);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Español'),
                  value: 'es',
                  groupValue: currentLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      currentLanguage = value!;
                    });
                    _saveLanguage(currentLanguage);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Français'),
                  value: 'fr',
                  groupValue: currentLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      currentLanguage = value!;
                    });
                    _saveLanguage(currentLanguage);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
