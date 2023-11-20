import 'package:flutter/material.dart';

class Notificationspage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Page'),
         backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text('Content for Notifications page'),
      ),
    );
  }
}
