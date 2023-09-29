import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/inputtextbox.dart';
import 'package:fridgemasters/widgets/textonlybutton.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:http/http.dart' as http;

class CreateAccountPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  CreateAccountPage({super.key});

  Future<void> registerUser(BuildContext context) async {
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
        // Handle successful registration
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        // Clear the text fields
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
      } else {
        // Handle error based on the message received from the server
        if (data["message"] == "Account already exists") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account already exists!')),
          );
        } else if (data["message"] == "Username is already taken") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username is already taken!')),
          );
        } else if (data["message"] == "Invalid email") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed!')),
          );
        }
        // Clear the text fields
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
      }
    } else {
      // Handle server connection error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to the server.')),
      );
    }
  }

  void handleSubmit(BuildContext context) {
    registerUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background1(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputTextBox(controller: usernameController, isPassword: false, hint: 'Create username'),
                const SizedBox(height: 20),
                InputTextBox(controller: emailController, isPassword: false, hint: 'Enter E-Mail'),
                const SizedBox(height: 20),
                InputTextBox(controller: passwordController, isPassword: true, hint: 'Create Password'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => handleSubmit(context),
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 20),
                TextOnlyButton(
                  text: 'Return To Login',
                  onPressed: () {
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
