import 'dart:ui';
import 'package:flutter/material.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/widgets/button.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'createaccount.dart';
import 'widgets/backgrounds.dart'; // Import the new Background1 widget


class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/your_project_folder/login.php'),
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'password': passwordController.text,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["success"]) {
        // Handle successful login, e.g., navigate to another page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to the server.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background1(), // Use the Background1 widget
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/fridgemasters-logo.png'), // Logo Image
                SizedBox(height: 20),
                InputTextBox(controller: usernameController, isPassword: false, hint: 'Username or Email'),
                SizedBox(height: 20),
                InputTextBox(controller: passwordController, isPassword: true, hint: 'Enter your password'),
                SizedBox(height: 20),
                Button(
                  onPressed: () {
                    // Your login logic here
                    login(context);
                  },
                  buttonText: 'Login',
                  nextPage: HomePage(),
                ),
                SizedBox(height: 20),
                TextOnlyButton(
                  text: 'Create Account',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccountPage()),
                    );
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
