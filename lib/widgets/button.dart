import 'package:flutter/material.dart';
import 'package:fridgemasters/audio_manager.dart'; // Import the AudioManager

class Button extends StatelessWidget {
  final Future<bool> Function() onPressed;
  final String buttonText;
  final Widget nextPage;
  final Color color; // Added the color property

  const Button({
    Key? key, 
    required this.onPressed,
    required this.buttonText,
    required this.nextPage,
    this.color = Colors.blue, // Set a default color
  }) : super(key: key); // Updated to include key in the super constructor

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Play click sound
        //AudioManager().playClickSound();
        bool success = await onPressed();
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        }
      },
      child: Text(buttonText),
      style: ElevatedButton.styleFrom(
        primary: color, // Used the color property here
      ),
    );
  }
}
