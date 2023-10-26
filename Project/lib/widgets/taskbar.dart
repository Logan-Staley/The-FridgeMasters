import 'package:flutter/material.dart';
import 'package:fridgemasters/foodentry.dart';
import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/recipes.dart';
import 'package:fridgemasters/audio_manager.dart';
import 'package:fridgemasters/inventory.dart'; // Import the file where FoodItem is defined

class Taskbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Function(FoodItem) onFoodItemAdded;

  const Taskbar({
    super.key, 
    required this.currentIndex, 
    required this.onTabChanged, 
    required this.onFoodItemAdded,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      // Inside your Taskbar widget build method
onTap: (index) {
  AudioManager().playClickSound();  // Play the click sound
  switch (index) {
    case 0:
      Navigator.popUntil(context, ModalRoute.withName('/'));  // Go back to HomePage
      break;
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoodEntry(
            onFoodItemAdded: (foodItem) {
              // Handle the new food item as necessary
            },
          ),
        ),
      );
      break;
    case 2:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Recipes()),
      );
      break;
    default:
      break;
  }
  onTabChanged(index);
},
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.kitchen),
          label: 'FoodEntry',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Recipes',
        ),
      ],
    );
  }
}
