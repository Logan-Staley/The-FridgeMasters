import 'package:flutter/material.dart';
import 'package:fridgemasters/audio_manager.dart'; // Import the AudioManager

class Button extends StatelessWidget {
  final Future<bool> Function() onPressed;
  final String buttonText;
  final Widget nextPage;
  final TextStyle textStyle; // Existing TextStyle parameter
  final Color color; // Existing color property

  const Button({
    Key? key, 
    required this.onPressed,
    required this.buttonText,
    required this.nextPage,
    this.textStyle = const TextStyle(color: Colors.black), // Default text style
    this.color = Colors.blue, // Default color
  }) : super(key: key); // Existing super constructor

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Play click sound
        // AudioManager().playClickSound();
        bool success = await onPressed();
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        }
      },
      child: Text(
        buttonText,
        style: textStyle, // Apply the textStyle to the Text widget
      ),
      style: ElevatedButton.styleFrom(
        primary: color, // Existing color usage
      ),
    );
  }
}
