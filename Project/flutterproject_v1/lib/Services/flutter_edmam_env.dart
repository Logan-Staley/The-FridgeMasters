// lib/services/edamam_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class EdamamApi {
  final String appId= '68dddfcc';
  final String appKey = '3da64a21932f13c170c859806396e97e';

  EdamamApi({required this.appId, required this.appKey});

  Future<Map<String, dynamic>> getRecipe(String query) async {
    final String apiUrl =
        "https://api.edamam.com/search?q=$query&app_id=$appId&app_key=$appKey";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipe');
    }
  }
}