import 'package:flutter/material.dart';
import 'HouseholdMembersPage.dart';
import 'PrivacySettingsPage.dart';
import 'SyncingOptionPage.dart';
import 'profile_information_page.dart';


class AccountSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile Information'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileInformationPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.sync),
            title: Text('Syncing Options'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SyncingOptionsPage()));
            },
          ),
          // ... [add the other settings pages similarly]
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Household Members'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HouseholdMembersPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Privacy Settings'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivacySettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}
