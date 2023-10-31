import 'package:flutter/material.dart';
import 'package:fridgemasters/recipesinstructions.dart';
import 'package:fridgemasters/widgets/button.dart'; // Import your Button widget
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:fridgemasters/widgets/taskbar.dart';

class Recipes extends StatelessWidget {
  const Recipes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes Page'),
      ),
      bottomNavigationBar: Taskbar(
        currentIndex: 2, // Assuming this is the second tab
        backgroundColor: Color.fromARGB(255, 233, 232, 232),
        onTabChanged: (index) {
          // Handle tab change if necessary
        },
        // If you don't need food item addition functionality in this page, you can remove this callback or make it optional in the Taskbar widget
        onFoodItemAdded: (foodItem) {
          // Handle food item addition if required
        },
      ),
      body: Stack(
        children: [
          Background(type: 'Background1'), // for Background1
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'AI Generated recipes based on your fridge food items',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 100),

                // Recipe Buttons using the Button widget
                Button(
                  onPressed: () async {
                    return true;
                  },
                  buttonText: 'First Recipe',
                  nextPage: const Recipesinstructions(),
                ),
                const SizedBox(height: 50),

                Button(
                  onPressed: () async {
                    return true;
                  },
                  buttonText: 'Second Recipe',
                  nextPage: const Recipesinstructions(),
                ),
                const SizedBox(height: 50),

                Button(
                  onPressed: () async {
                    return true;
                  },
                  buttonText: 'Third Recipe',
                  nextPage: const Recipesinstructions(),
                ),
                const SizedBox(height: 50),

                Button(
                  onPressed: () async {
                    return true;
                  },
                  buttonText: 'Fourth Recipe',
                  nextPage: const Recipesinstructions(),
                ),
                const SizedBox(height: 50),

                // Back Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Recipesinstructions()));
                  },
                  child: const Text('Back'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Example destination page for a recipe details screen

