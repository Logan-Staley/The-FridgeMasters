import 'package:flutter/material.dart';
import 'package:fridgemasters/theme_notifier.dart';
import 'package:provider/provider.dart';



class DisplayBrightnessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.themeData.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Display and Brightness')),
      body: ListTile(
        title: Text('Dark Theme'),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (value) {
            if (value) {
              themeNotifier.setTheme(ThemeData.dark());
            } else {
              themeNotifier.setTheme(ThemeData.light());
            }
          },
        ),
      ),
    );
  }
}

