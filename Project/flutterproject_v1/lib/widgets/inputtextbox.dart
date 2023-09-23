import 'package:flutter/material.dart';

class InputTextBox extends StatelessWidget {
  final bool isPassword;
  final String hint;

  // Define the width and height for the InputTextBox
  final double width = 300.0;
  final double height = 50.0;

  InputTextBox({required this.isPassword, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: TextField(
        obscureText: isPassword, // If true, the text will be obscured with dots
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hint,
        ),
      ),
    );
  }
}
