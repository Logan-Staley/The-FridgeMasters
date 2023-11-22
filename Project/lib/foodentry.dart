import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:fridgemasters/Services/storage_service.dart';
import 'inventory.dart';
import 'widgets/inputtextbox.dart';
import 'widgets/textonlybutton.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Recipe {
  final String label;
  final String image;
  final String source;
  final String url;

  Recipe({
    required this.label,
    required this.image,
    required this.source,
    required this.url,
  });

  factory Recipe.fromMap(Map<String, dynamic> data) {
    return Recipe(
      label: data['label'] ?? '',
      image: data['image'] ?? '',
      source: data['source'] ?? '',
      url: data['url'] ?? '',
    );
  }
}

class FoodEntry extends StatefulWidget {
  final Function(FoodItem) onFoodItemAdded;
  const FoodEntry({super.key, required this.onFoodItemAdded});

  @override
  _FoodEntryState createState() => _FoodEntryState();
}

// ... (imports remain unchanged)

class _FoodEntryState extends State<FoodEntry> {
  String _productName = '';
  String _imageUrl = '';

  Map<String, dynamic> _nutrientsInfo = {};
  List<Recipe> _recipes = [];

  // ... (rest of the code remains unchanged)

  Future<void> processEdamamData(Map<String, dynamic> data,
      {bool isUpc = false}) async {
    String imageUrl = '';
    String productName = '';

    if (data.containsKey('hints') &&
        data['hints'] is List &&
        data['hints'].isNotEmpty) {
      Map<String, dynamic> firstHint = data['hints'][0];
      if (firstHint.containsKey('food') && firstHint['food'] is Map) {
        Map<String, dynamic> foodData = firstHint['food'];
        imageUrl = foodData.containsKey('image') ? foodData['image'] : '';
      }
    }

    if (isUpc) {
      if (data.containsKey('hints') &&
          data['hints'] is List &&
          data['hints'].isNotEmpty &&
          data['hints'][0] is Map &&
          data['hints'][0].containsKey('food') &&
          data['hints'][0]['food'] is Map &&
          data['hints'][0]['food'].containsKey('label')) {
        productName = data['hints'][0]['food']['label'];
      }
    } else {
      productName = foodItemNameController.text;
    }

    Map<String, dynamic> nutrients = {};

    var foodInfoList =
        (data['parsed'] as List).isNotEmpty ? data['parsed'] : data['hints'];

    if (foodInfoList.isNotEmpty) {
      var foodData = foodInfoList[0]['food'];
      if (foodData != null && foodData.containsKey('nutrients')) {
        nutrients = foodData['nutrients'];
      }
    }

    setState(() {
      if (foodItemNameController.text.isEmpty) {
        _productName = productName;
      } else {
        _productName = foodItemNameController.text;
      }

      _imageUrl = imageUrl;
      _nutrientsInfo = nutrients;
    });

    // Call saveToInventory with the extracted data
    saveToInventory(productName: _productName, imageUrl: _imageUrl);
  }

  // ... (rest of the code remains unchanged)

  @override
  Widget build(BuildContext context) {
    // ... (rest of the code remains unchanged)
  }
}
