import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorial Page'),
      ),
      body: Center(
        child: Text('Welcome to the Tutorial!'),
      ),
    );
  }
}
