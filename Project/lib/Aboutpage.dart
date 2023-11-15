import 'package:flutter/material.dart';

class Aboutpage extends StatelessWidget {
<<<<<<< HEAD
  // Function to launch email
  void _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'TheFridgeMastersuhcl@gmail.com', // Replace with your actual support email
       // Replace with your actual support email
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      print("Could not launch email client.");
    }
  }

=======
>>>>>>> parent of c0ea12f (commit)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About page'),
      ),
      body: Center(
        child: Text('Content About page'),
      ),
    );
  }
}
