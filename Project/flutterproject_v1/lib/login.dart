import 'package:flutter/material.dart';
import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/widgets/button.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'createaccount.dart';
import 'widgets/backgrounds.dart'; // Import the new Background1 widget
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fridgemasters/ForgotPasswordPage.dart';

class LoginPage extends StatelessWidget {
  // Create TextEditingController instances
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  Future<bool> login(BuildContext context) async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both username and password.')),
      );
      return true;
      //Change this from TRUE -> to verfiy password/username is correct
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1/login.php'), // Update this URL if needed
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
        return true; // Return true on successful login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
        return false; // Return false on failed login
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to the server.')),
      );
      return false; // Return false on server connection error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background1(), // Use the Background1 widget
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/fridgemasters-logo.png'), // Logo Image
                const SizedBox(height: 20),
                // Provide the controllers to the InputTextBox widgets
                InputTextBox(
                  controller: usernameController,
                  isPassword: false,
                  hint: 'Username or Email',
                ),
                const SizedBox(height: 20),
                InputTextBox(
                  controller: passwordController,
                  isPassword: true,
                  hint: 'Enter your password',
                ),
                const SizedBox(height: 20),
                Button(
                  onPressed: () => login(context),
                  buttonText: 'Login',
                  nextPage: HomePage(),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                TextOnlyButton(
                  text: 'Forgot Password',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
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
