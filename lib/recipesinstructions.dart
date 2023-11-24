import 'package:flutter/material.dart';

class Recipesinstructions extends StatelessWidget {
  const Recipesinstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Instructions Page'),
      ),
      body: const Center(
        child: Text('This is the Recipe Instructions page.'),
      ),
    );
  }
}