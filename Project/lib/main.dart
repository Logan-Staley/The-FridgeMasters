import 'package:flutter/material.dart';

import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/login.dart';
import 'splash_screen.dart'; // Import the SplashScreen widget
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'audio_manager.dart';
import 'package:provider/provider.dart';
import 'package:fridgemasters/Services/user_provider.dart';
import 'package:fridgemasters/theme.dart';
import 'package:fridgemasters/theme_notifier.dart';
import 'language_change_notifier.dart';
import 'package:fridgemasters/language.dart';
import 'package:fridgemasters/Tutorial.dart';
=======
import 'splash_screen.dart'; // Import the SplashScreen widget
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'audio_manager.dart';
import 'package:provider/provider.dart';
import 'package:fridgemasters/Services/user_provider.dart';
import 'theme_notifier.dart';
import 'material_theme_data.dart';

void main() async {
  await dotenv.load(fileName: 'edamam.env');
  final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
     );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.orange,
    // Customize other dark theme properties here
  );

  final themeNotifier = ThemeNotifier(lightTheme, false);
  runApp(MyApp(themeNotifier, darkTheme));
}

class MyApp extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  final ThemeData darkTheme;

  MyApp(this.themeNotifier, this.darkTheme);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>.value(value: themeNotifier),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: Consumer2<ThemeNotifier, UserProvider>(
        builder: (context, themeNotifier, userProvider, child) {
          return MaterialApp(
            title: 'FridgeMasters App',
            theme: themeNotifier.themeData,
            darkTheme: darkTheme, // Assuming you have a dark theme defined
            themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
=======
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier(lightTheme)),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: Consumer2<ThemeNotifier, UserProvider>(
        builder: (context, themeNotifier, userProvider, child) {
          return MaterialApp(
            title: 'FridgeMasters App',
            theme: themeNotifier.themeData,
            initialRoute: '/',
            routes: {
              '/': (context) =>
              LoginPage(), 
              '/home': (context) => HomePage(fridgeItems: []),
              '/login': (context) => LoginPage(),// Replace with your initial page
              // Define other routes here
            },
          );
        },
      ),
    );
  }
}
