import 'package:flutter/material.dart';
import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/login.dart';
import 'splash_screen.dart'; // Import the SplashScreen widget
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'audio_manager.dart';
import 'package:provider/provider.dart';
import 'package:fridgemasters/Services/user_provider.dart';


void main() async {
  await dotenv.load(fileName: 'edamam.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'My App',
        initialRoute: '/',  // Initial route when the app starts
        routes: {
          '/': (context) => LoginPage(),
          '/home': (context) => HomePage(fridgeItems: [],),   // HomePage is named '/home'
          // ... add other routes if needed
        },
      ),
    );
  }
}

