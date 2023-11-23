import 'package:flutter/material.dart';

class InputTextBox extends StatelessWidget {
  final bool isPassword;
  final String hint;
  final TextEditingController controller; // Add this line

  // Define the width and height for the InputTextBox
  final double width = 300.0;
  final double height = 50.0;

  const InputTextBox({super.key, 
    required this.isPassword,
    required this.hint,
    required this.controller, // Add this line
  });

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
        controller: controller, // Add this line
        obscureText: isPassword, // If true, the text will be obscured with dots
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide.none, // Remove the default border
          ),
          hintText: hint,
        ),
      ),
    );
  }
}
