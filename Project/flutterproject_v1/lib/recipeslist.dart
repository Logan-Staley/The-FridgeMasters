import 'package:flutter/material.dart';

class RecipesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes List Page'),
      ),
      body: Center(
        child: Text('This is the Recipes List page.'),
      ),
    );
  }
}