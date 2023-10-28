import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'audio_manager.dart';
import 'package:provider/provider.dart';
import 'package:fridgemasters/Services/user_provider.dart';
import 'theme_notifier.dart'; 
import 'material_theme_data.dart'; 

void main() async {
  await dotenv.load(fileName: 'edamam.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeNotifier(lightTheme), 
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'My App',
            theme: themeNotifier.themeData,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
