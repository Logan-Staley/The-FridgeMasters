import 'package:flutter/material.dart';
import 'package:fridgemasters/foodentry.dart';
import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/recipes.dart';

class Taskbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const Taskbar({super.key, required this.currentIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );

            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FoodEntry()),
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
