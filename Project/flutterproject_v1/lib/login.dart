import 'package:flutter/material.dart';
import 'package:fridgemasters/homepage.dart'; // Make sure to import HomePage
import 'package:fridgemasters/widgets/button.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'createaccount.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputTextBox(isPassword: false, hint: 'Username or Email'),
            SizedBox(height: 20),
            InputTextBox(isPassword: true, hint: 'Enter your password'),
            SizedBox(height: 20),
            Button(
              onPressed: () {
                // Your login logic here
              },
              buttonText: 'Login',
              nextPage: HomePage(), // Pass the HomePage here
            ),
            SizedBox(height: 20),
            TextOnlyButton(
              text: 'Create Account',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAccountPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
