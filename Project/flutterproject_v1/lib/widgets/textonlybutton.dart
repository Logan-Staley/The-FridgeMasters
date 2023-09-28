import 'package:flutter/material.dart';

class TextOnlyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  TextOnlyButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          shadows: [
            Shadow(
              blurRadius: 3.0,
              color: Colors.white, // Changed the shadow color to white
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
    );
  }
}
