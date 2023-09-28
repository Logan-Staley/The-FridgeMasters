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
              onPressed: () async {
                return true;
              },
              buttonText: 'First Recipe',
              nextPage: Recipesinstructions(),
            ),
            SizedBox(height: 50),

            Button(
              onPressed: () async {
                return true;
              },
              buttonText: 'Second Recipe',
              nextPage: Recipesinstructions(),
            ),
            SizedBox(height: 50),

            Button(
              onPressed: () async {
                return true;
              },
              buttonText: 'Third Recipe',
              nextPage: Recipesinstructions(),
            ),
            SizedBox(height: 50),

            Button(
              onPressed: () async {
                return true;
              },
              buttonText: 'Fourth Recipe',
              nextPage: Recipesinstructions(),
            ),
            SizedBox(height: 50),

            // Back Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Recipesinstructions()));
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

