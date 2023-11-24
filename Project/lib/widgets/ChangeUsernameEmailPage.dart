
import 'package:flutter/material.dart';
import 'package:fridgemasters/Services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangeUsernameEmailPage extends StatefulWidget {
  @override
  _ChangeUsernameEmailPageState createState() =>
      _ChangeUsernameEmailPageState();
}

class _ChangeUsernameEmailPageState extends State<ChangeUsernameEmailPage> {//Logan S
//Logan S
  final _formKey = GlobalKey<FormState>();
  String _newUsernameEmail = '';

  void _updateUsernameEmail() async {
    final storageService = StorageService();
    String? userId = await storageService.getStoredUserId();
    final response = await http.post(
      Uri.parse(
          'http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/Changeusername.php'),
      body: {
        'userId': userId,
        'newUsernameEmail': _newUsernameEmail,
      },
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Username/Email updated successfully');
    } else {
      // Handle error
      print('Failed to update Username/Email');
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new username or email';
                }
                if (value.contains('@') && !_isValidEmail(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
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
