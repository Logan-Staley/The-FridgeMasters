import 'package:flutter/material.dart';

class InputTextBox extends StatelessWidget {
  final bool isPassword;
  final String hint;
  final TextEditingController? controller; // Define the controller parameter

  // Define the width and height for the InputTextBox
  final double width = 300.0;
  final double height = 50.0;

  InputTextBox({required this.isPassword, required this.hint, this.controller}); // Add the controller parameter to the constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white
            .withOpacity(0.3), // Nearly transparent white background
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller, // Use the controller if provided
        obscureText: isPassword, // If true, the text will be obscured with dots
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none, // Remove the default border
          ),
          hintText: hint,
        ),
      ),
    );
  }
}
