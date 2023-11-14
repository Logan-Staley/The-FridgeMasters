import 'package:flutter/material.dart';
import 'path_to_tutorial_page/Tutorialpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to TutorialPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TutorialPage()),
            );
          },
          child: Text('Go to Tutorial Page'),
        ),
      ),
    );
  }
}
