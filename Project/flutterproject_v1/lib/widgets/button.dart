import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Future<bool> Function() onPressed;
  final String buttonText;
  final Widget nextPage;

  Button({
    required this.onPressed,
    required this.buttonText,
    required this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        bool success = await onPressed();
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        }
      },
      child: Text(buttonText),
    );
  }
}
