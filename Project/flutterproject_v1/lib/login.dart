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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputTextBox(isPassword: false, hint: 'Username or Email'),
            SizedBox(height: 20),
            InputTextBox(isPassword: true, hint: 'Enter your password'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
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
