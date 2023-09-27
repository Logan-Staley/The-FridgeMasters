import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/taskbar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      
      body: Center(
        child: Text('Welcome to the Home Page!'),
        

      

      ),

      bottomNavigationBar: Taskbar(currentIndex: 0, onTabChanged: (index){
        
      }
      
      
      
      
      )
       
    );

    
  }
   



}
