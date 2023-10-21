import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import the SplashScreen widget
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'audio_manager.dart';

void main() async {
  await dotenv.load(fileName: 'edamam.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: SplashScreen(), // Set SplashScreen as the initial screen
    );
  }
}
