import 'package:flutter/material.dart';
import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/login.dart';
<<<<<<< HEAD
import 'package:fridgemasters/theme.dart';
import 'package:provider/provider.dart'; // Import theme.dart where you have lightTheme and darkTheme definitions
import 'theme_notifier.dart'; // Import your ThemeNotifier
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  WidgetsFlutterBinding.ensureInitialized(); // Required if you're using async code before runApp
  await dotenv.load(fileName: 'edamam.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MultiProvider( providers: [
ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => LanguageChangeNotifier()),

    ],
      //create: (context) => ThemeNotifier(),
      child: Consumer2<ThemeNotifier, LanguageChangeNotifier>(
        builder: (context, themeNotifier, languageNotifier, child) {
          return MaterialApp(
            title: 'FridgeMasters App',
            theme: lightTheme,
            darkTheme: darkTheme, // Assuming you have a dark theme defined
            themeMode: themeNotifier.themeMode,
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
              '/tutorial': (context) => TutorialPage(),
            },
          );
        },
      ),
    );
  }
}
