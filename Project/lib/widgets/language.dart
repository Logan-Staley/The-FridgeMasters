import 'package:flutter/material.dart';
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
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizedValues[currentLanguage]!['title']!),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Background(type: 'Background1') // for Background1
              ),
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
