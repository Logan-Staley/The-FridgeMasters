// recipes_page.dart
import 'package:flutter/material.dart';

class recipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes Page'),
      ),
      body: Center(
        child: Text('This is the Recipes Page'),
      ),
    );
  }
}