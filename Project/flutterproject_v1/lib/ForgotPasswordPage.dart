import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/inputtextbox.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  // This function simulates sending a password reset email
  void sendPasswordResetEmail(BuildContext context) {
    String email = emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email.')),
      );
      return;
    }
    // In a real app, you'd try to send a password reset email here

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password reset email sent to $email')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputTextBox(
              controller: emailController,
              isPassword: true,
              hint: 'Enter your password',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendPasswordResetEmail(context);
              },
              child: Text('Send Password Reset Email'),
            ),
          ],
        ),
      ),
    );
  }
}
