import 'package:flutter/material.dart';

class InputTextBox extends StatelessWidget {
  final bool isPassword;
  final String hint;
  final TextEditingController controller;
  final Color textColor;
  final Color backgroundColor; // Use this in decoration

  // Define the width and height for the InputTextBox
  final double width = 300.0;
  final double height = 50.0;

  const InputTextBox({Key? key, 
    required this.isPassword,
    required this.hint,
    required this.controller, 
    this.textColor = Colors.black87,
    this.backgroundColor = Colors.white, // Default value set to white
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor, // Use backgroundColor here
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: textColor), // Use textColor for the input text
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide.none, // Remove the default border
          ),
          hintText: hint,
          hintStyle: TextStyle(color: textColor.withOpacity(0.5)), // Hint text color
        ),
      ),
    );
  }
}

