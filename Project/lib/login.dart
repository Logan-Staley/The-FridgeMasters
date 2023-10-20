import 'package:flutter/material.dart';
import 'package:fridgemasters/homepage.dart';
import 'package:fridgemasters/widgets/button.dart';
import 'package:fridgemasters/resetpassword.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'createaccount.dart';
import 'widgets/backgrounds.dart'; // Import the new Background1 widget
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fridgemasters/widgets/animated_logo.dart';
import 'package:audioplayers/audioplayers.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  
  _LoginPageState createState() => _LoginPageState();
  final player = AudioPlayer();
}

class _LoginPageState extends State<LoginPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _showAnimation = true;
  
class LoginPage extends StatelessWidget {
  // Create TextEditingController instances
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  Future<bool> login(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/login.php'),
        body: {
          'username_or_email': usernameController.text,
          'password': passwordController.text,
        },
      );

      var data = jsonDecode(response.body);
      if (data["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );

      _changeToAfterLoginMusic();  // Change music after successful login
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred")),
      );
      return false;
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
        Image.asset('images/fridgemasters-logo.png'),
        const SizedBox(height: 20),
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
              MaterialPageRoute(builder: (context) => CreateAccountPage()),
            );
          },
        ),
        const SizedBox(height: 20),
        TextOnlyButton(
          text: 'Forgot Password?',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => resetpassword()),
            );
          },
        ),
      ],
    );
  }
}
