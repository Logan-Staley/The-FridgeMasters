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
      Uri.parse(
          'http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/create_account.php'),
      body: {
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    var data = jsonDecode(response.body);
    if (data["success"]) {
      // Handle successful registration
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"])),
      );
      // Clear the text fields
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
    } else {
      // Handle error based on the message received from the server
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"])),
      );
      // Clear the text fields
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
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
          const Background(type: 'Background1'), // for Background1
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputTextBox(
                    controller: usernameController,
                    isPassword: false,
                    hint: 'Create username'),
                const SizedBox(height: 20),
                InputTextBox(
                    controller: emailController,
                    isPassword: false,
                    hint: 'Enter E-Mail'),
                const SizedBox(height: 20),
                InputTextBox(
                    controller: passwordController,
                    isPassword: true,
                    hint: 'Create Password'),
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
