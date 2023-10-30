import 'package:http/http.dart' as http;

Future<void> deleteItem(String userId, String itemKey) async {
  final Uri url = Uri.parse(
      'http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/delete_inventory.php');

  final response = await http.post(url, body: {
    'userId': userId,
    'itemKey': itemKey,
  });

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print("Failed to delete item");
  }
}
