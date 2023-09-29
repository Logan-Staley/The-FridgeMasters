import 'package:flutter/material.dart';
import 'login.dart'; // Import the LoginPage widget

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: LoginPage(), // Set LoginPage as the initial screen
    );
  }
}
