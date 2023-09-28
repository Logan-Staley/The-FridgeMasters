import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/widgets/button.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'createaccount.dart';
import 'widgets/backgrounds.dart'; // Import the new Background1 widget

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background1(), // Use the Background1 widget
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/fridgemasters-logo.png'), // Logo Image
                SizedBox(height: 20),
                InputTextBox(isPassword: false, hint: 'Username or Email'),
                SizedBox(height: 20),
                InputTextBox(isPassword: true, hint: 'Enter your password'),
                SizedBox(height: 20),
                Button(
                  onPressed: () {
                    // Your login logic here
                  },
                  buttonText: 'Login',
                  nextPage: HomePage(),
                ),
                SizedBox(height: 20),
                TextOnlyButton(
                  text: 'Create Account',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccountPage()),
                    );
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
