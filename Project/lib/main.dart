import 'package:flutter/material.dart';
import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/login.dart';
import 'package:fridgemasters/widgets/theme.dart';
import 'package:provider/provider.dart'; // Import theme.dart where you have lightTheme and darkTheme definitions
import 'theme_notifier.dart'; // Import your ThemeNotifier
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'language_change_notifier.dart';
import 'package:fridgemasters/language.dart';
import 'package:fridgemasters/Tutorialpage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required if you're using async code before runApp
  await dotenv.load(fileName: 'edamam.env');

  // Initialize log file
  await _initializeLogFile();

  runApp(MyApp());
}

Future<void> _initializeLogFile() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/inventory_log1.txt');
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
  } catch (e) {
    print('Error creating log file: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => LanguageChangeNotifier()),
      ],
      //create: (context) => ThemeNotifier(),
      child: Consumer2<ThemeNotifier, LanguageChangeNotifier>(
        builder: (context, themeNotifier, languageNotifier, child) {
          return MaterialApp(
            title: 'FridgeMasters App',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme, // Assuming you have a dark theme defined
            themeMode: themeNotifier.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => LoginPage(),
              '/home': (context) => HomePage(fridgeItems: []),
              '/login': (context) =>
                  LoginPage(), // Replace with your initial page
              // Define other routes here
              '/tutorial': (context) => TutorialPage(),
            },
          );
        },
      ),
    );
  }
}
