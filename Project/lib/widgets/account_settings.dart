import 'package:flutter/material.dart';
import 'ChangePasswordPage.dart'; // Make sure to create this page
import 'ChangeUsernameEmailPage.dart'; // Make sure to create this page

class AccountSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Settings'),
      backgroundColor: Theme.of(context).primaryColor,),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: Text('Change Password'),
            onTap: () {
              // Navigate to the ChangePasswordPage
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePasswordPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.alternate_email),
            title: Text('Change Username/Email'),
            onTap: () {

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeUsernameEmailPage()));
            },
          ),
        ],
      ),
    );
  }
}