import 'package:flutter/material.dart';
import 'package:fridgemasters/foodentry.dart';
import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/recipes.dart';

class Taskbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  Taskbar({required this.currentIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        switch(index){
          case 0:
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()), );
        
       break;
        case 1: 
        Navigator.push(context, MaterialPageRoute(builder: (context) => foodentry()), );

        break;
         case 2:
          Navigator.push(context, MaterialPageRoute(builder: (context) => recipes()), );
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
          label: 'Foodentry',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Recipes',
        ),
      ],
    );
    
  }
}
