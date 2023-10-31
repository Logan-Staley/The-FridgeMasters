import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodItem {
  final String itemId;
  final String name;
  final int quantity;
  final String dateOfPurchase;
  final String expirationDate;

  FoodItem({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.dateOfPurchase,
    required this.expirationDate,
  });
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

  Future<List<FoodItem>> fetchUserInventory() async {
    final response = await http.post(Uri.parse('http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/get_user_inventory.php'));
    final Map<String, dynamic> responseData = json.decode(response.body);
    
    if (responseData['status'] == 'success') {
      final List<dynamic> data = responseData['data'];
      return data.map((item) => FoodItem(
        itemId: item['ItemID'],
        name: item['name'],
        quantity: int.parse(item['quantity']),
        dateOfPurchase: item['dateOfPurchase'],
        expirationDate: item['expirationDate'],
      )).toList();
    } else {
      // Handle error accordingly
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
