//Page implemented by Logan S

import 'package:flutter/material.dart';
import 'package:fridgemasters/login.dart';
import 'package:fridgemasters/resetpasswordverfied.dart';
import 'package:fridgemasters/widgets/ChangePasswordPage.dart';
import 'package:fridgemasters/widgets/button.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/backgrounds.dart'; // Import the new Background1 widget
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Services/storage_service.dart'; // Import StorageService

class ResetPassword extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> verifyUser(BuildContext context) async {
    final storageService = StorageService(); // Add StorageService
    try {
      final response = await http.post(
        Uri.parse(
            'http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/Verifyaccount.php'),
        body: {
          'Username': usernameController.text,
          'Email': emailController.text,
        },
      );

      var data = jsonDecode(response.body);

      if (data["success"]) {
        // Save the UserID using StorageService
        await storageService.setStoredUserId(data["UserID"].toString());

        // Navigate to the password change page
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => resetpasswordverfied()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred")),
      );
    }
  }

//Implemented  by Logan S
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(type: 'Background1'),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/FinalLOGO.png'),
                const SizedBox(height: 20),
                InputTextBox(
                  controller: emailController,
                  isPassword: false,
                  hint: 'Email',
                  textColor: Colors.black87,
                  backgroundColor: Colors.grey[200]!,
                ),
                const SizedBox(height: 20),
                InputTextBox(
                  controller: usernameController,
                  isPassword: false,
                  hint: 'Username',
                  textColor: Colors.black87,
                  backgroundColor: Colors.grey[200]!,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Button(
                          onPressed: () async {
                            await verifyUser(context);
                            return true;
                          },
                          buttonText: 'Reset',
                          nextPage: resetpasswordverfied(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Button(
                          onPressed: () {
                            Navigator.of(context).pop();
                            return Future.value(true);
                          },
                          buttonText: 'Back',
                          nextPage: LoginPage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
