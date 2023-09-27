import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/widgets/button.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'createaccount.dart'; // Import the CreateAccountPage


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/test-food-image.jpg'), // Replace with the path of your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust the blur level as needed
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.black.withOpacity(0.3), // Semi-transparent container
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/fridgemasters-logo.png'), // Logo Image
                  SizedBox(height: 20), // Spacing between logo and input field
                  InputTextBox(isPassword: false, hint: 'Username or Email'),
                  SizedBox(height: 20),
                  InputTextBox(isPassword: true, hint: 'Enter your password'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20),
                  TextOnlyButton(
                    text: 'Create Account',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateAccountPage()), // Navigate to CreateAccountPage
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}