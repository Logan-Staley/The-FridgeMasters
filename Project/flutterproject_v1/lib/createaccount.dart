import 'dart:convert';
import 'package:flutter/material.dart';
import 'widgets/inputtextbox.dart';
import 'package:http/http.dart' as http;

class CreateAccountPage extends StatelessWidget {
  // Step 1: Create TextEditingController instances
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> registerUser() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/register.php'),
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["success"]) {
        // Handle successful registration, e.g., navigate to another page or show a success message
      } else {
        // Handle error, e.g., show an error message
      }
    } else {
      // Handle server connection error
    }
  }

  // Step 1: Create the submit function
  void handleSubmit() {
    registerUser();
    // Here, you'd typically send these values to a server or perform some other action.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Create Account')),
      body: Center(
        child: Column(
          children: [
            // Step 2: Provide the controllers to the InputTextBox widgets
            InputTextBox(
                controller: usernameController,
                isPassword: false,
                hint: 'Enter username'),
            InputTextBox(
                controller: emailController, isPassword: false, hint: 'E-Mail'),
            InputTextBox(
                controller: passwordController,
                isPassword: true,
                hint: 'Password'),

            ElevatedButton(
              onPressed: handleSubmit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
