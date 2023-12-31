//Logan Staley's Code ------
import 'package:flutter/material.dart';
import 'package:fridgemasters/Services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  String _retypePassword = '';

  void _changePassword() async {
    //Logan S
    final storageService = StorageService();
    String? UserID = await storageService.getStoredUserId();
    final response = await http.post(
      Uri.parse(
          'http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/Changepassword.php'),
      body: {
        'userId':
            UserID, // Make sure this matches the PHP script's expected key
        'newPassword': _newPassword,
        'currentPassword': _currentPassword,
      },
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Password changed successfully');
    } else {
      // Handle error
      print('Failed to change password');
    }
  }

  bool _isPasswordCompliant(String password, [int minLength = 5]) {
    if (password.isEmpty) {
      return false;
    }
    bool hasMinLength = password.length >= minLength;
    bool hasSpecialCharacter =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasMinLength && hasSpecialCharacter;
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                if (!_isPasswordCompliant(value)) {
                  return 'Password must be at least 5 characters long and include special characters';
                }
                if (value != _retypePassword) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Retype New Password'),
              obscureText: true,
              onChanged: (value) => _retypePassword = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please retype the new password';
                }
                if (_newPassword != value) {
                  return 'Passwords do not match';
                }
                return null;
              },
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

//Logan Staley's Code ------