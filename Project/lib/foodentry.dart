import 'package:flutter/material.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'inventory.dart';


class FoodEntry extends StatefulWidget {
  const FoodEntry({super.key});

  @override
  _FoodEntryState createState() => _FoodEntryState();
}

class _FoodEntryState extends State<FoodEntry> {
  TextEditingController foodItemNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController dateOfPurchaseController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();

  List<FoodItem> foodItemList = [];

  void saveToInventory() {
    final foodItem = FoodItem(
      name: foodItemNameController.text,
      quantity: int.tryParse(quantityController.text) ?? 0,
      dateOfPurchase: dateOfPurchaseController.text,
      expirationDate: expirationDateController.text,
    );

    setState(() {
      foodItemList.add(foodItem);
    });

    // Clear the text controllers
    foodItemNameController.clear();
    quantityController.clear();
    dateOfPurchaseController.clear();
    expirationDateController.clear();
  }

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
              isPassword: false,
              hint: 'Ex: Strawberries, Milk, Cheese',
              controller: foodItemNameController,
            ),
            const SizedBox(height: 20),

            const Text('Quantity'),
            InputTextBox(
              isPassword: false,
              hint: 'Ex: 20',
              controller: quantityController,
            ),
            const SizedBox(height: 20),

            const Text('Date of Purchase'),
            InputTextBox(
              isPassword: false,
              hint: 'Ex: 12/21/2023',
              controller: dateOfPurchaseController,
            ),
            const SizedBox(height: 20),

            const Text('Expiration Date'),
            InputTextBox(
              isPassword: false,
              hint: 'Ex: 12/21/2023',
              controller: expirationDateController,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                saveToInventory();
              },
              child: const Text('Save'),
            ),


             const SizedBox(height: 20),
                       ElevatedButton(
              onPressed: () {
                // Navigate to the inventory page when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => inventory(foodItemList: foodItemList)), // Replace with your actual InventoryPage
                );
              },
              child: const Text('Go to Inventory'), // Button text
            ),
            
            const SizedBox(height: 20),
            TextOnlyButton(
              text: 'Cancel',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}