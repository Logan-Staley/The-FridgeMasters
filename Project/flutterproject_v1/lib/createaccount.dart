import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/inputtextbox.dart';
import 'package:fridgemasters/widgets/textonlybutton.dart'; // Import TextOnlyButton
import 'package:fridgemasters/widgets/backgrounds.dart'; // Make sure the import path is correct

class CreateAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Create Account')),
      body: Stack(
        children: [
          Background1(), // Use the Background1 widget
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputTextBox(isPassword: false, hint: 'Create username'),
                SizedBox(height: 20), // Add some spacing between the inputs
                InputTextBox(isPassword: false, hint: 'Enter E-Mail'),
                SizedBox(height: 20), // Add some spacing between the inputs
                InputTextBox(isPassword: true, hint: 'Create Password'),
                SizedBox(height: 20), // Add some spacing between the inputs
                TextOnlyButton(
                  text: 'Return To Login',
                  onPressed: () {
                    // Navigate back to the previous page
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
