import 'package:flutter/material.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';


class foodentry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Inventory'),
      ),
     
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Food Item'),
            InputTextBox( isPassword: true,hint: 'Ex: Strawberries, Milk,Cheese'),
            SizedBox(height: 20),

            Text('Quantity'),
            InputTextBox( isPassword: true,hint: 'Ex: 20'),
            SizedBox(height: 20),

            Text('Date of Purchase'),
            InputTextBox( isPassword: false,hint: 'Ex: 12/21/2023'),
            SizedBox(height: 20),

            Text('Expiration Date'),
            InputTextBox( isPassword: false,hint: 'Ex: 12/21/2023'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => foodentry()));
            },
            child: Text('Save'),

            ),
            SizedBox(height: 20),
            TextOnlyButton(
              text: 'Cancel',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          foodentry()), // Navigate to CreateAccountPage
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
