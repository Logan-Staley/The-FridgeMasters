import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/inputtextbox.dart';

class ForgotPasswordPage extends StatelessWidget {
  // A TextEditingController is used to read text entered into a TextField.
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordPage({super.key});

  // This function is responsible for handling the password reset email request.
  void sendPasswordResetEmail(BuildContext context) {
    // Retrieve the email entered by the user.
    String email = emailController.text;

    // Check if the email field is empty and show a message if it is.
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email.')),
      );
      return;
    }

    // Provide feedback to the user indicating that the password reset email was sent.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password reset email sent to $email')),
    );
  }

  // The build method returns the widget tree that constructs the UI of the page.
  @override
  Widget build(BuildContext context) {
    // The Scaffold widget provides a top-level container that holds the structure of the visual interface.
    return Scaffold(
      // The AppBar is a Material widget that can hold titles, icons, and actions.
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      // Padding is added to provide some spacing around the content of the page.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // A Column widget is used to arrange its children widgets in a vertical manner.
        child: Column(
          // mainAxisAlignment is used to align the children widgets along the main axis.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputTextBox(
              controller: emailController,
              isPassword: true,
              hint: 'Enter your password',
            ),
            // SizedBox is used to create space between widgets.
            const SizedBox(height: 20),
            // ElevatedButton is a Material Design raised button.
            ElevatedButton(
              // When the button is pressed, the `sendPasswordResetEmail` function is called.
              onPressed: () {
                sendPasswordResetEmail(context);
              },
              child: const Text('Send Password Reset Email'),
            ),
          ],
        ),
      ),
    );
  }
}
