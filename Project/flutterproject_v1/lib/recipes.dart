// recipes_page.dart
import 'package:flutter/material.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'package:fridgemasters/widgets/button.dart';

class recipes extends StatelessWidget {
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
            'AI Generated recipes based on your fridge food items ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
            SizedBox(height: 100), // Add space here


            Text('First Recipe'),
            InputTextBox( isPassword: true,hint: 'Ex: Strawberries, Milk,Cheese'),
            SizedBox(height: 20),

             Text('Second Recipe'),
            InputTextBox( isPassword: true,hint: 'Ex: Strawberries, Milk,Cheese'),
            SizedBox(height: 20),

             Text('Third Recipe'),
            InputTextBox( isPassword: true,hint: 'Ex: Strawberries, Milk,Cheese'),
            SizedBox(height: 20),

             Text('Fourth Recipe'),
            InputTextBox( isPassword: true,hint: 'Ex: Strawberries, Milk,Cheese'),
            SizedBox(height: 20),
          ]
        ),
      ),
    );
  }
}