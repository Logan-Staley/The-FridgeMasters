import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseService {
  final String baseURL = 'http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/get_user_inventory.php';

  Future<List<Map<String, dynamic>>> getUserInventory(String userId) async {
    final response = await http.post(
      Uri.parse('$baseURL/get_user_inventory.php'),
      body: {'userId': userId},
    );

    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      return List<Map<String, dynamic>>.from(responseBody);
    } else {
      throw Exception('Failed to load inventory');
    }
  }
}
