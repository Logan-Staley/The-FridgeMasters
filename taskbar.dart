import 'package:flutter/material.dart';

class Taskbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  Taskbar({required this.currentIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabChanged,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.kitchen),
          label: 'Fridge',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Recipes',
        ),
      ],
    );
  }
}
