import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fridgemasters/language_change_notifier.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String currentLanguage = 'en';
  _saveLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    Provider.of<LanguageChangeNotifier>(context, listen: false)
        .changeLanguage(lang);
  }

  _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentLanguage = prefs.getString('language') ?? 'en';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color appBarColor = theme.primaryColor;
    final Color activeColor = Colors.blue;
    final languageNotifier = Provider.of<LanguageChangeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          languageNotifier.localizedStrings['title']!,
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
                  languageNotifier.localizedStrings['content']!,
                  style: theme.textTheme.headline6,
                ),
                SizedBox(height: 20),
                _buildLanguageOption('en', languageNotifier, activeColor),
                _buildLanguageOption('es', languageNotifier, activeColor),
                _buildLanguageOption('fr', languageNotifier, activeColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String value,
      LanguageChangeNotifier languageNotifier, Color activeColor) {
    return RadioListTile<String>(
      title: Text(languageNotifier.localizedStrings['title'] ?? 'Default Title',
          style: Theme.of(context).textTheme.subtitle1),
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
