import 'package:flutter/material.dart';

class ScrollableTextBox extends StatelessWidget {
  final String text;

  const ScrollableTextBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16.0),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
