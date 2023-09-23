import 'package:flutter/material.dart';

class TextOnlyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  TextOnlyButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
