import 'package:flutter/material.dart';

class ParagraphTextBox extends StatelessWidget {
  final String text;

  const ParagraphTextBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }
}
