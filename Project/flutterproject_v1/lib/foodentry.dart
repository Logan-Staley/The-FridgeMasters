import 'package:flutter/material.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';

class FoodEntry extends StatelessWidget {
  // Create TextEditingController instances
  final TextEditingController foodItemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();

  FoodEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to Inventory'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Food Item'),
            InputTextBox(
              controller: foodItemController,
              isPassword: false,
              hint: 'Ex: Strawberries, Milk, Cheese',
            ),
            const SizedBox(height: 20),

            const Text('Quantity'),
            InputTextBox(
              controller: quantityController,
              isPassword: false,
              hint: 'Ex: 20',
            ),
            const SizedBox(height: 20),

            const Text('Date of Purchase'),
            InputTextBox(
              controller: purchaseDateController,
              isPassword: false,
              hint: 'Ex: 12/21/2023',
            ),
            const SizedBox(height: 20),

            const Text('Expiration Date'),
            InputTextBox(
              controller: expirationDateController,
              isPassword: false,
              hint: 'Ex: 12/21/2023',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => FoodEntry()));
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
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
