import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;

  Button({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
     child: Text(''),  // Text displayed on the button
    );
  }
}


//This is a small button for login, save, cancel.
// First Button used in Login: Changed text to login in the login.dart page