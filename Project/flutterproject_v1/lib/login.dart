import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'createaccount.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputTextBox(controller: usernameController, isPassword: false, hint: 'Username or Email'),
            SizedBox(height: 20),
            InputTextBox(controller: passwordController, isPassword: true, hint: 'Enter your password'),
            SizedBox(height: 20),
            TextOnlyButton(
              text: 'Login',
              onPressed: () {
                login(context);
              },
            ),
            TextOnlyButton(
              text: 'Create Account',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAccountPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
