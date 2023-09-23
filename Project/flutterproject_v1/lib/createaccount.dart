import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/inputtextbox.dart';

class CreateAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Create Account')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputTextBox(isPassword: false, hint: 'Enter username'),
            SizedBox(height: 20), // Add some spacing between the inputs
            InputTextBox(isPassword: false, hint: 'E-Mail'),
            SizedBox(height: 20), // Add some spacing between the inputs
            InputTextBox(isPassword: true, hint: 'Password'),
          ],
        ),
      ),
    );
  }
}
