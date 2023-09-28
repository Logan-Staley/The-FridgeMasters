import 'package:flutter/material.dart';
import 'package:fridgemasters/recipesinstructions.dart';
import 'package:fridgemasters/widgets/button.dart'; // Import your Button widget

class Recipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'AI Generated recipes based on your fridge food items',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 100),

            // Recipe Buttons using the Button widget
            Button(
              onPressed: () {
                // Handle navigation or recipe action for the first recipe here
              },
              buttonText: 'First Recipe',
              nextPage: Recipesinstructions(), // Replace with the actual destination page
            ),
            SizedBox(height: 50),

            Button(
              onPressed: () {
                // Handle navigation or recipe action for the second recipe here
              },
              buttonText: 'Second Recipe',
              nextPage: Recipesinstructions(), // Replace with the actual destination page
            ),
            SizedBox(height: 50),

            Button(
              onPressed: () {
                // Handle navigation or recipe action for the third recipe here
              },
              buttonText: 'Third Recipe',
              nextPage: Recipesinstructions(), // Replace with the actual destination page
            ),
            SizedBox(height: 50),

            Button(
              onPressed: () {
                // Handle navigation or recipe action for the food item here
              },
              buttonText: 'Fourth Recipe',
              nextPage: Recipesinstructions(), // Replace with the actual destination page
            ),
            SizedBox(height: 50),

            // Back Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Recipesinstructions()));
              },
              child: Text('Back'),
            )
          ],
        ),
      ),
    );
  }
}

// Example destination page for a recipe details screen

