import 'package:flutter/material.dart';
import 'inventory.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:intl/intl.dart';

class FoodEntry extends StatefulWidget {
  final Function(FoodItem) onFoodItemAdded;
  const FoodEntry({super.key, required this.onFoodItemAdded});

  @override
  _FoodEntryState createState() => _FoodEntryState();
}

class _FoodEntryState extends State<FoodEntry> {
  TextEditingController foodItemNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController dateOfPurchaseController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();

String formatDateString(String dateStr) {
    try {
      DateFormat inputFormat = DateFormat("MM/dd/yyyy");
      DateTime date = inputFormat.parse(dateStr);
      DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      return outputFormat.format(date);
    } catch (e) {
      print('Error parsing date: $e');
      return '';
    }
  }

  void saveToInventory() {
    final formattedDateOfPurchase = formatDateString(dateOfPurchaseController.text);
    final formattedExpirationDate = formatDateString(expirationDateController.text);

    final foodItem = FoodItem(
      name: foodItemNameController.text,
      quantity: int.tryParse(quantityController.text) ?? 0,
      dateOfPurchase: formattedDateOfPurchase,
      expirationDate: formattedExpirationDate,
    );

    print("Adding to fridge: ${foodItem.name}");
    widget.onFoodItemAdded(foodItem);
  }

  void clearFields() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to clear the fields?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                foodItemNameController.clear();
                quantityController.clear();
                dateOfPurchaseController.clear();
                expirationDateController.clear();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to Inventory'),
      ),
      body: Stack(
        children: [
          Background1(),
          Center(
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
                  onPressed: saveToInventory,
                  child: const Text('Add to Fridge'),
                ),
                const SizedBox(height: 20),
                TextOnlyButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}