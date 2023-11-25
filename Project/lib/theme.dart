//Mathilde G

import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: Colors.amber, // replaces the old 'accentColor'
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.black),
    headline1: TextStyle(color: Colors.black),
    // Define other text styles as needed
  ),
  // Other light theme properties...
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey,
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
  ).copyWith(
    secondary: Colors.lightBlueAccent,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.white),
    headline1: TextStyle(color: Colors.white),
    // Define other text styles as needed
  ),
  // Other dark theme properties...
);
