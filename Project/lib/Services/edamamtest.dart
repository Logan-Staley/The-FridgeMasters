//Logan S
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<bool> checkApiConnection() async {
  final apiUrl = dotenv.env['API_URL']!;
  final appId = dotenv.env['APP_ID']!;
  final appKey = dotenv.env['APP_KEY']!;

  try {
    final response = await http.get(
      Uri.parse('$apiUrl?app_id=$appId&app_key=$appKey'),
    );

    if (response.statusCode == 200) {
      print('Connected to API successfully!');
      return true;
    } else {
      print('Failed to connect to API: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error occurred: $e');
    return false;
  }
}
