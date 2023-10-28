import 'package:flutter/material.dart';

import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/login.dart';
import 'splash_screen.dart'; // Import the SplashScreen widget

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'audio_manager.dart';
import 'package:provider/provider.dart';
import 'package:fridgemasters/Services/user_provider.dart';
import 'theme_notifier.dart'; 
import 'material_theme_data.dart'; 


void main() async {
  await dotenv.load(fileName: 'edamam.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier(lightTheme)),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
child: Consumer2<ThemeNotifier, UserProvider>(
        builder: (context, themeNotifier, userProvider, child) {
          return MaterialApp(
            title: 'My App',
            theme: themeNotifier.themeData,
            initialRoute: '/',
            routes: {
              '/': (context) => LoginPage(), // Or LoginPage() if you want to start with the login page
              '/home': (context) => HomePage(
                    fridgeItems: [],
                  ), 
              '/login': (context) => LoginPage(),
              // ... add other routes if needed
            },
          );
        },
      ),
    );
  }
}

