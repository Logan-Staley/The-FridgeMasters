import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue, // Example primary color for light theme
  accentColor: Colors.amber, // Example accent color for light theme
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.black),
    headline1: TextStyle(color: Colors.black),
    // Define other text styles as needed
  ),
  // Other light theme properties...
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey, // Example primary color for dark theme
  accentColor: Colors.amber, // Example accent color for dark theme
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.white),
    headline1: TextStyle(color: Colors.white),
    // Define other text styles as needed
  ),
  // Other dark theme properties...
);
