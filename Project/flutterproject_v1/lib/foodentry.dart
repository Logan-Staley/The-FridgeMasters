import 'package:flutter/material.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';

class FoodEntry extends StatelessWidget {
  // Create TextEditingController instances
  final TextEditingController foodItemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();

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
            InputTextBox(
              controller: foodItemController,
              isPassword: false,
              hint: 'Ex: Strawberries, Milk, Cheese',
            ),
            SizedBox(height: 20),

            Text('Quantity'),
            InputTextBox(
              controller: quantityController,
              isPassword: false,
              hint: 'Ex: 20',
            ),
            SizedBox(height: 20),

            Text('Date of Purchase'),
            InputTextBox(
              controller: purchaseDateController,
              isPassword: false,
              hint: 'Ex: 12/21/2023',
            ),
            SizedBox(height: 20),

            Text('Expiration Date'),
            InputTextBox(
              controller: expirationDateController,
              isPassword: false,
              hint: 'Ex: 12/21/2023',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => FoodEntry()));
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
                          FoodEntry()), // Navigate to CreateAccountPage
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
