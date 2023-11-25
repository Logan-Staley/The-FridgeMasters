// TODO Implement this library.
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';

  void _changePassword() {
    // Implement your change password logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
              onChanged: (value) => _currentPassword = value,
              // Add validators as necessary
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
              onChanged: (value) => _newPassword = value,
              // Add validators as necessary
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              child: Text('Change Password'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _changePassword();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
//ODO Implement this library.