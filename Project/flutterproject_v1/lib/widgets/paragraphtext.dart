import 'package:flutter/material.dart';

class ParagraphTextBox extends StatelessWidget {
  final String text;

  ParagraphTextBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }
}
