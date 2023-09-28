import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:fridgemasters/notificationlist.dart'; // Import NotificationList
import 'package:fridgemasters/settings.dart'; // Import Settings
import 'package:fridgemasters/widgets/backgrounds.dart'; // Import Background1

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.notifications), // Notifications icon
          onPressed: () {
            // Navigate to NotificationList page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationList()),
            );
          },
        ),
        // No title here, so the center is empty
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to Settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Background1(), // This will be your background
          Center(
              // Your other widgets go here
              ),
        ],
      ),
      bottomNavigationBar: Taskbar(
        currentIndex: 0,
        onTabChanged: (index) {
          // Handle tab change
        },
      ),
    );
  }
}
