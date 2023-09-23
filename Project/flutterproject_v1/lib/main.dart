import 'package:flutter/material.dart';
import 'login.dart'; // Import the LoginPage widget

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: LoginPage(), // Set LoginPage as the initial screen
    );
  }
}
