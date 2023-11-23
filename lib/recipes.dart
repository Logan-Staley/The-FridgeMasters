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
                // White background with black text
                Container(
                  color: const Color.fromARGB(255, 117, 116, 116),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Given the items in your fridge, these are some recipe suggestions you can try:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // First Recipe Button moved up
                Container(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Recipesinstructions(),
                        ),
                      );
                    },
                    child: const Text('First Recipe'),
                  ),
                ),
                const SizedBox(height: 20), // Added spacing between buttons

                // Second Recipe Button
                Container(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                    
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Recipesinstructions(),
                        ),
                      );
                    },
                    child: const Text('Second Recipe'),
                    
                  ),
                  
                ),
                const SizedBox(height: 20),

                // Third Recipe Button
                Container(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Recipesinstructions(),
                        ),
                      );
                    },
                    child: const Text('Third Recipe'),
                  ),
                ),
                const SizedBox(height: 20),

                // Fourth Recipe Button
                Container(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Recipesinstructions(),
                        ),
                      );
                    },
                    child: const Text('Fourth Recipe'),
                  ),
                ),
                const SizedBox(height: 20),

                // Fifth Recipe Button
                Container(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Recipesinstructions(),
                        ),
                      );
                    },
                    child: const Text('Fifth Recipe'),
                  ),
                ),
                const SizedBox(height: 50),

                // Back Button with spacing
                Container(
                  
                  child: ElevatedButton(
  onPressed: () {
    // Navigate back to the homepage at index 0
    Navigator.of(context).pushReplacementNamed('/home');
  },
  style: ElevatedButton.styleFrom(
    primary: const Color.fromARGB(0, 0, 0, 0), // Make the background color transparent
  ),
  child: Text(
    'Back',
    style: TextStyle(
      color: Color.fromARGB(255, 255, 255, 255), // Text color
    ),
  ),
),
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
