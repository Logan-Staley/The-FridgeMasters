import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final int quantity;
  final String dateOfPurchase;
  final String expirationDate;

  FoodItem({
    required this.name,
    required this.quantity,
    required this.dateOfPurchase,
    required this.expirationDate,
  });
}

class inventory extends StatelessWidget {
  final List<FoodItem> foodItemList;

  inventory({required this.foodItemList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Log'),
      ),
      body: ListView.builder(
        itemCount: foodItemList.length,
        itemBuilder: (context, index) {
          final foodItem = foodItemList[index];
          return ListTile(
            title: Text('Food Item: ${foodItem.name}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantity: ${foodItem.quantity.toString()}'),
                Text('Date of Purchase: ${foodItem.dateOfPurchase}'),
                Text('Expiration Date: ${foodItem.expirationDate}'), // Accessing instance member correctly
              ],
            ),
          );
        },
      ),
    );
  }
}
