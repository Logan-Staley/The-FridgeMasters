import 'package:flutter/material.dart';
import 'login.dart';
import  'audio_manager.dart';
import 'animated_logo.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    // Optionally start background music or any initialization here
    AudioManager().startBackgroundMusic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // If AnimatedLogo does not take width, remove the width property.
        child: AnimatedLogo(
          onAnimationCompleted: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Stop any background music when the splash screen is disposed
    AudioManager().stopBackgroundMusic();
    super.dispose();
  }
}

