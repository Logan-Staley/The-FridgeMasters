import 'package:flutter/material.dart';
import 'package:fridgemasters/Aboutpage.dart';
import 'package:fridgemasters/Tutorialpage.dart';
import 'package:fridgemasters/widgets/language.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:fridgemasters/login.dart';
import 'package:fridgemasters/widgets/account_settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fridgemasters/Notificationspage.dart';
import 'package:provider/provider.dart';
import 'package:fridgemasters/theme_notifier.dart';
import 'package:google_fonts/google_fonts.dart';

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
      /*Created by Freddie and removed by Freddie.
      case 'Language':
        nextPage = Language();
        break;
      */
      case 'Notifications':
        nextPage = Notificationspage();
        break;

      case 'About':
        nextPage = Aboutpage();
        break;
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text('Settings', style: GoogleFonts.calligraffitti(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: Theme.of(context).primaryColor,
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
          const Background(type: 'Background1'), // for Background1
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ListTile(
                  title: Text('Account'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('Account'),
                ),
                /*        Created by Freddie. Also, removed by Freddie.
                ListTile(
                  title: Text('Language'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('Language'),
                ),
                */
                /* ListTile(
                  title: Text('Notifications'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('Notifications'),
                ),
                */
                ListTile(
                  title: Text('About'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToSetting('About'),
                ),
//ListTile(title: Text('Watch Tutorial'),
//onTap: () {Navigator.of(context).push (MaterialPageRoute(builder: (context)=> TutorialPage(onSkip: (){})),);},)
//,
                ListTile(
                  title: Text('View Tutorial'),
                  leading: Icon(Icons.video_library),
                  onTap: () {
                    // Navigate to Tutorial Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TutorialPage()),
                    );
                  },
                ),

                ListTile(
                  title: Text('Theme'),
                  trailing: ElevatedButton(
                    onPressed: () =>
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .toggleTheme(),
                    //themeNotifier.toggleTheme();

                    child: Text('Toggle Theme'

                        //themeNotifier.themeMode == ThemeMode.dark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                        ),
                  ),
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
