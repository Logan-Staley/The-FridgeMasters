import 'package:flutter/material.dart';
import 'package:fridgemasters/Aboutpage.dart';
import 'package:fridgemasters/FAQpage.dart';
import 'package:fridgemasters/System.dart';
import 'package:fridgemasters/Tutorialpage.dart';
import 'package:fridgemasters/widgets/language.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:fridgemasters/login.dart';
import 'package:fridgemasters/widgets/account_settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fridgemasters/audio_manager.dart';

import 'package:fridgemasters/widgets/display_and_brightness.dart';
//import 'package:fridgemasters/FAQpage.dart';
//import 'package:fridgemasters/Aboutpage.dart';
import 'package:fridgemasters/Notificationspage.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _selectedLanguage = 'English';
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> _playLogoutSound() async {
    await _audioPlayer.play(UrlSource('sounds/logout_sound.mp3'));
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Sign Out'),
          content: Text('Do you really want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                await _playLogoutSound();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToSetting(String category) {
    Widget? nextPage;
    switch (category) {
      case 'Account':
        nextPage = AccountSettings();
        break;

      case 'Language':
        nextPage = Language();
        break;
      case 'Notifications':
        nextPage = Notificationspage();
        break;
      case 'System':
        nextPage = System();
        break;
      case 'FAQs':
        nextPage = FAQpage();
        break;
      case 'About':
        nextPage = Aboutpage();
        break;
      case 'Display and Brightness':
        nextPage = DisplayBrightnessPage();
        break;
      case 'Tutorial':
        nextPage = Tutorialpage();
        break;

      // Add more cases for other categories here...
    }

    if (nextPage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage!),
      );
    }
    print("Navigating to $category settings");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
              print("Search pressed");
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const Background1(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ListTile(
                  title: Text('Account'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('Account'),
                ),
                ListTile(
                  title: Text('Language'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('Language'),
                ),

                ListTile(
                  title: Text('Notifications'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('Notifications'),
                ),
                ListTile(
                  title: Text('System'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('System'),
                ),
                ListTile(
                  title: Text('FAQs'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('FAQs'),
                ),
                ListTile(
                  title: Text('About'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('About'),
                ),
                ListTile(
                  title: Text('Display and Brightness'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('Display and Brightness'),
                ),
                ListTile(
                  title: Text('Tutorialpage'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('Tutorialpage'),
                ),
                SizedBox(
                    height:
                        20), // Spacer doesn't work in ListView. Replacing with SizedBox.
                ElevatedButton(
                  onPressed: () {
                    //    AudioManager().playClickSound(); - don't feel it's necessary here
                    _showConfirmationDialog(context);
                  },
                  child: const Text('Sign Out'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
