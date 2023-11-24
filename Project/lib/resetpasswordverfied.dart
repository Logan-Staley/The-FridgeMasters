//Page implemented by Logan S
import 'package:flutter/material.dart';
import 'package:fridgemasters/Services/storage_service.dart';
import 'package:fridgemasters/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class resetpasswordverfied extends StatefulWidget {
  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<resetpasswordverfied> {
  final _formKey = GlobalKey<FormState>();
  String _newPassword = '';
  String _retypePassword = '';

  void _changePassword() async {
    final storageService = StorageService();
    String? UserID = await storageService.getStoredUserId();
    final response = await http.post(
      Uri.parse(
          'http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/ChangepasswordRequest.php'),
      body: {
        'userId': UserID, // Use the stored UserID
        'newPassword': _newPassword,
      },
    );
    var data = jsonDecode(response.body);
    if (data["success"]) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully')),
      );

      // Navigate to the login page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Handle error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to change password')));
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
