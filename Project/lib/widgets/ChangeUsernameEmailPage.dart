// TODO// TODO Implement this library.// ChangeUsernameEmailPage.dart
import 'package:flutter/material.dart';

class ChangeUsernameEmailPage extends StatefulWidget {
  @override
  _ChangeUsernameEmailPageState createState() => _ChangeUsernameEmailPageState();
}

class _ChangeUsernameEmailPageState extends State<ChangeUsernameEmailPage> {
  final _formKey = GlobalKey<FormState>();
  String _newUsernameEmail = '';

  void _updateUsernameEmail() {
    // Implement your update username/email logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Username/Email')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'New Username/Email'),
              onChanged: (value) => _newUsernameEmail = value,
              // Add validators as necessary
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              child: Text('Update Username/Email'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updateUsernameEmail();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
// Implement this library.