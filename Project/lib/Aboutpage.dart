import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching email
import 'package:google_fonts/google_fonts.dart';

class Aboutpage extends StatelessWidget {
  // Function to launch email
  void _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'TheFridgeMastersuhcl@gmail.com', // Replace with your actual support email
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
        title: Text('About Us', style: GoogleFonts.calligraffitti(fontSize: 24.0, fontWeight: FontWeight.bold,)),
        //backgroundColor: theme.appBarTheme.backgroundColor,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo at the top of the page
                Image.asset('images/FinalLOGO.png'), 
                SizedBox(height: 20),
                // "About Us" text content
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RichText(
                    text: TextSpan(
                      //style: theme.textTheme.bodyText1,
                       style: GoogleFonts.lato( // Changed to Lato for a more elegant look
                        fontSize: 16, // Adjust the font size as needed
                        color: theme.textTheme.bodyText1?.color, // Choose a color that fits your theme
                      ),
                      children: [
                        TextSpan(
                          text: 'Fall 2023 Senior Project at the University of Houston-Clear Lake\n\n\n'
                                'The seed of FridgeMasters was planted by Michael Ndudim, an IT Major. Inspired by Michael\'s vision, a team of dynamic individuals from various fields came together to bring this idea to life. \n\n'
                                'Our Team:\n\n'
                                'Logan Staley - CS Major\n'
                                'Freddy Munoz - CIS Major\n'
                                'Mireya Carino - CIS Major\n'
                                'Massiray Taylor-Kamara - IT Major\n'
                                'Mathilde E Guissou - CIS Major\n\n'
                                'Our Purpose:\n'
                          'At FridgeMasters, we believe in making your life easier. Our mobile app is designed to help you keep track of your food inventory, minimize waste, and optimize meal planning. With integrated functionalities like recipe suggestions, nutritional tracking, and inventory management, we\'re here to simplify and revolutionize household food management.\n\n'
                  'Our Goal:\n'
                          'To create a sustainable and efficient kitchen ecosystem, empowering users to make informed decisions about their food consumption and waste. We aim to foster a community that values healthy eating and environmentally conscious living.\n\n'
                          'Our Vision:\n'
                                'Each member of the team, contributing with their unique skills and enthusiasm, collaboratively shaped and enhanced the initial concept, transforming our vision to reality.\n\n' 
                                'The FridgeMasters application stands as a testament to this shared dream and goal which is to revolutionize household food management.\n\n'
                                'Our journey has been one of collaboration, learning, and immense growth. We hope you find FridgeMasters not only useful but also a significant step towards mindful, sustainable living.\n\n' 
                                'Your feedback and support inspire us to keep innovating and improving.\n\n'
                                '"Optimized Space. Optimized Taste."\n\n',
                        ),
                        TextSpan(
                          text: 'The FridgeMasters',
                          style: GoogleFonts.calligraffitti(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 80), // Space at the bottom for the floating button
              ],
            ),
          ),
          // Floating Action Button for email
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
