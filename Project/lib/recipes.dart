import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridgemasters/recipesinstructions.dart';
import 'package:fridgemasters/widgets/button.dart'; // Import your Button widget
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:fridgemasters/widgets/taskbar.dart';

class Recipes extends StatelessWidget {
  const Recipes({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes Page',style: GoogleFonts.calligraffitti(fontSize: 24.0,
      fontWeight: FontWeight.bold,),
        
        ),
        backgroundColor: theme.primaryColor,
      ),
      bottomNavigationBar: Taskbar(
        currentIndex: 2, // Assuming this is the second tab
        backgroundColor: theme.bottomAppBarColor,
        //Color.fromARGB(255, 233, 232, 232),
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
                  //color: Color.fromARGB(243, 116, 117, 117),
                  //color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Given the items in your fridge, these are some recipe suggestions you can try:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.textTheme.bodyText1?.color,),
                   // style: TextStyle(
                     // fontSize: 14,
                      //fontWeight: FontWeight.bold,
                      //color: Colors.white,
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


                // Back Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Recipesinstructions()));
                  },
                  child: const Text('Back'),
                  style: ElevatedButton.styleFrom(
                    primary: theme.colorScheme.secondary,
                )

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
