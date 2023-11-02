import 'package:http/http.dart' as http;
import 'package:fridgemasters/Services/storage_service.dart';

Future<void> deleteItem(String ItemID) async {
  final storageService = StorageService();

  // Fetch stored userId from storage
  String? userID = await storageService.getStoredUserId();

  final response = await http.post(
      Uri.parse(
          'http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/delete_inventory.php'),
      body: {
        'userID': userID,
        'itemKey': ItemID,

      });

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print("Failed to delete item with status: ${response.statusCode}");
    print("Response body: ${response.body}");
  }
}
