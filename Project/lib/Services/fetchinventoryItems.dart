//Logan S
//Michael Ndudim
import 'dart:convert';
import 'package:fridgemasters/inventory.dart';
import 'package:http/http.dart' as http;

Future<List<FoodItem>> fetchInventoryItems() async {
  final response = await http.get(Uri.parse('http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/get_user_inventory.php'));

  if (response.statusCode == 200) {
    // If the server returns an OK response, parse the JSON
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((item) => FoodItem(
      itemId: item['itemId'],
      name: item['name'],
      quantity: item['quantity'],
      dateOfPurchase: item['dateOfPurchase'],
      expirationDate: item['expirationDate'],
      imageUrl: item['imageUrl'] ?? 'default_image.png',
      nutrients: item['nutrients'], // Add this line
    )).toList();
    
  } else {
    // If the server did not return a 200 OK response, throw an exception
    throw Exception('Failed to load inventory items');
  }
}
