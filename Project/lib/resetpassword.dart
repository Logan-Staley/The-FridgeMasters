import 'package:flutter/material.dart';
import 'package:fridgemasters/login.dart';
import 'package:fridgemasters/widgets/button.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/backgrounds.dart'; // Import the new Background1 widget
import 'dart:convert';
import 'package:http/http.dart' as http;

class resetpassword extends StatelessWidget {
  // Create TextEditingController instances
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  resetpassword({super.key});

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
          const Background(type: 'Background1'), // Use the Background1 widget
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/FinalLOGO.png'), // Logo Image
                const SizedBox(height: 20),
                // Provide the controllers to the InputTextBox widgets
                InputTextBox(
                  controller: usernameController,
                  isPassword: false,
                  hint: 'Email',
                  textColor: Colors.black87,
          backgroundColor: Colors.grey[200]!,
                ),
                SizedBox(height: 20), // Add spacing between the textbox and buttons
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 50.0), // Adjust the horizontal padding as needed
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    mainAxisSize: MainAxisSize.min, // Make the row only as wide as necessary
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0), // Spacing between buttons
        child: Button(
          onPressed: () async {
            return await login(context); // Return the result of login function
          },
          buttonText: 'Reset',
          nextPage: LoginPage(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0), // Spacing between buttons
        child: Button(
          onPressed: () {
            Navigator.of(context).pop(); // Go back
            return Future.value(true); // Return a completed future
          },
          buttonText: 'Back',
          nextPage: LoginPage(),
        ),
      ),
    ],
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }


}

