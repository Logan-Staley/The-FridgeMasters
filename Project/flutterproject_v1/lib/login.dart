import 'package:flutter/material.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'createaccount.dart'; // Import the CreateAccountPage

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
            TextOnlyButton(
              text: 'Create Account',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateAccountPage()), // Navigate to CreateAccountPage
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
