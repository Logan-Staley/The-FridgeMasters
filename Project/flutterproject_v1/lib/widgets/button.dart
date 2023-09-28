import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Widget nextPage; // Add this line to accept the next page

  Button(
      {required this.onPressed,
      required this.buttonText,
      required this.nextPage}); // Modify the constructor

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Text(buttonText),
    );
  }
}
