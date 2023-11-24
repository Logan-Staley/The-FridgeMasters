// Page created by:
//Logan S
//Michael Ndudim

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodItem {
  final String itemId;
  final String name;
  final int quantity;
  final String dateOfPurchase;
  final String expirationDate;
  final String imageUrl; 
  final Map<String, dynamic> nutrients; // For nutritional data

  FoodItem({
    required this.itemId, 
    required this.name,
    required this.quantity,
    required this.dateOfPurchase,
    required this.expirationDate,
    required this.imageUrl,
    required this.nutrients,
  });

  // Add a factory constructor to create an instance from JSON data
  factory FoodItem.fromJson(Map<String, dynamic> json) {
  return FoodItem(
    itemId: json['itemId'].toString(),
    name: json['productName'],
    quantity: int.parse(json['quantity'].toString()),
    dateOfPurchase: json['dateOfPurchase'],
    expirationDate: json['expirationDate'],
    imageUrl: json['imageUrl'] ?? 'default_image.png',
    nutrients: json['nutrients'] ?? {},
  );
}
}

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<FoodItem> foodItemList = [];

  @override
  void initState() {
    super.initState();
    fetchUserInventory().then((items) {
      setState(() {
        foodItemList = items;
      });
    });
  }
 // Add a method to get food item names
  List<String> getFoodItemNames() {
    return foodItemList.map((item) => item.name).toList();
  }
Future<List<FoodItem>> fetchUserInventory() async {
  // Send the HTTP request
  final response = await http.post(
    Uri.parse('http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/get_user_inventory.php'));

  // Print the raw response body for debugging
  print('Response Body: ${response.body}');

  // Decode the JSON response
  final Map<String, dynamic> responseData = json.decode(response.body);

  // Check and handle the response status
  if (responseData['status'] == 'success') {
    final List<dynamic> data = responseData['data'];

    // Print the raw data list for debugging
    print('Raw Data: $data');

    // Parse the data into FoodItem objects
    List<FoodItem> items = data.map((item) => FoodItem(
      itemId: item['ItemID'],
      name: item['name'],
      quantity: int.parse(item['quantity']),
      dateOfPurchase: item['dateOfPurchase'],
      expirationDate: item['expirationDate'],
      imageUrl: item['imageUrl'] ?? 'default_image.png',
      nutrients: item['nutrients'] ?? {}, // Ensure this matches the backend response
    )).toList();

    // Print the parsed FoodItem objects for debugging
    for (var foodItem in items) {
      print('FoodItem: ${foodItem.name}, Nutrients: ${foodItem.nutrients}');
    }

    return items;
  } else {
    // Handle error accordingly
    print('Error: Failed to load inventory. Status: ${responseData['status']}');
    throw Exception('Failed to load inventory.');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Log'),
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
                Text('Expiration Date: ${foodItem.expirationDate}'),
              ],
            ),
            
          );
        },
      ),
    );
  }
}
