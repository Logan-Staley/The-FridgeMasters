// This page was created by: 
//Logan S
//Michael Ndudim

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
//Register function created by:
//Logan S
//Michael Ndudim
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"])),
      );
    }

    usernameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  void handleSubmit(BuildContext context) {
    registerUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color fixedButtonColor = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account',  style: TextStyle(
            color: Colors.white, 
            // Default to white if titleTextStyle is not set
            fontSize: 20 // You can adjust the font size as needed
        //style: theme.textTheme.headline6),
       // backgroundColor: theme.appBarTheme.backgroundColor,
      ),
        ),
        //backgroundColor: theme.primaryColor,
        backgroundColor: Colors.blue,

      ),
      body: Stack(
        children: [
          Background(type: 'Background1'), // Consistent background
          Center(
            child: SingleChildScrollView( // Makes the page scrollable
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputTextBox(
                    controller: usernameController,
                    isPassword: false,
                    hint: 'Create username',
                    textColor: Colors.black87,
          backgroundColor: Colors.grey[200]!,
                  ),
                  const SizedBox(height: 20),
                  InputTextBox(
                    controller: emailController,
                    isPassword: false,
                    hint: 'Enter E-Mail',
                    textColor: Colors.black87,
          backgroundColor: Colors.grey[200]!,
                  ),
                  const SizedBox(height: 20),
                  InputTextBox(
                    controller: passwordController,
                    isPassword: true,
                    hint: 'Create Password',
                    textColor: Colors.black87,
          backgroundColor: Colors.grey[200]!,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
  onPressed: () => handleSubmit(context),
  child: Text(
    'Submit',
    style: TextStyle(color: Colors.white), // Set text color to white
  ),
  style: ElevatedButton.styleFrom(
    primary: fixedButtonColor,
  ),
),
                  const SizedBox(height: 20),
                  TextButton(
                    
                    onPressed: () => Navigator.pop(context),
                    child: Text ( 'Return To Login',
                    style: TextStyle ( color: fixedButtonColor,) ,),
                      
                  ),
                ],
            ),
              ),
          ),
        ],
      ),
      
    );
  }
}
