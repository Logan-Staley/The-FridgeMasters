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
        // Handle successful registration
      } else {
        // Handle error
      }
    } else {
      // Handle server connection error
    }
  }

  void handleSubmit() {
    registerUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background1(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputTextBox(controller: usernameController, isPassword: false, hint: 'Create username'),
                SizedBox(height: 20),
                InputTextBox(controller: emailController, isPassword: false, hint: 'Enter E-Mail'),
                SizedBox(height: 20),
                InputTextBox(controller: passwordController, isPassword: true, hint: 'Create Password'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: Text('Submit'),
                ),
                SizedBox(height: 20),
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
