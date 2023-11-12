import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching email

class Aboutpage extends StatelessWidget {
  // Function to launch email
  void _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@fridgemasters.com', // Replace with your actual support email
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      print("Could not launch email client.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('About Us', style: theme.textTheme.headline6),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyText1,
                      children: [
                        TextSpan(
                          text: 'About Us - FridgeMasters\n\n'
                          'Fall 2023 Senior Project at the University of Houston-Clear Lake\n\n'
                          'FridgeMasters is not merely a project; it\'s a testament to professionalism, innovation, and collaborative excellence achieved by a team of senior students at the University of Houston-Clear Lake. Initiated in the fall of 2023, our venture stands as a paragon of how student dedication, combined with a clear vision, can lead to remarkable outcomes. Our journey from a concept to a fully-functional application epitomizes our commitment to not just meet but exceed expectations.\n\n'
                          // ... rest of the 'About Us' text ...
                          'FridgeMasters - Where innovation meets convenience in kitchen management.\n\n'
                        ),
                        TextSpan(
                          text: 'The FridgeMasters',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (theme.textTheme.headline6?.fontSize ?? 16)  + 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Image.asset('images/FinalLOGO.png'), // Replace with your logo asset
                SizedBox(height: 80), // Space for the floating button
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: _sendEmail,
              child: Icon(Icons.email, color: Colors.white),
              tooltip: 'Contact Support',
            ),
          ),
        ],
      ),
    );
  }
}
