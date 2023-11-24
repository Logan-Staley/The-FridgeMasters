import 'package:flutter/material.dart';
import 'login.dart'; 
import 'audio_manager.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AudioManager().startBackgroundMusic();
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => LoginPage())
            );
          },
          child: Text('Start App'),
        ),
      ),
    );
  }
}
