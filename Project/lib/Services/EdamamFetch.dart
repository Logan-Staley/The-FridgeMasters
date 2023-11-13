import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<String>> fetchSuggestions(String query) async {
  await dotenv.load(fileName: "edamam.env");
  final apiKey = dotenv.env['API_Key_FOOD'] ??
      '3da64a21932f13c170c859806396e97e'; // Provide a fallback value
  final appId =
      dotenv.env['API_ID_FOOD'] ?? '68dddfcc'; // Provide a fallback value
  final apiUrl = dotenv.env['API_URL_FOOD'] ??
      'https://api.edamam.com/api/food-database/v2/parser'; // Provide a default URL

  // Check if the API key and ID are not empty
  final url =
      Uri.parse('$apiUrl?q=$query&limit=5'); // Adjust the limit as needed

  try {
    // Send an HTTP GET request to the Edamam API
    final response = await http.get(
      url,
      headers: {
        'app_id': appId,
        'app_key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      // Parse the response and process the data
      return parseSuggestions(response.body);
    } else {
      // Handle HTTP errors
      throw Exception('HTTP Error: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network or other errors
    throw Exception('Error: $e');
  }
}

List<String> parseSuggestions(String responseBody) {
  // Implement your JSON parsing logic here
  // For example:
  final parsed = json.decode(responseBody);
  // Extract and return suggestions from the parsed JSON
  return List<String>.from(
      parsed['hints'].map((data) => data['food']['label']));
}
