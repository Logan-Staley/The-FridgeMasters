import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridgemasters/recipesinstructions.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:http/http.dart' as http;
import 'foodentry.dart'; // Import the file where Recipe is defined
import 'dart:convert'; // Import json for decoding the response
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Make sure to include this package for .env access
import 'inventory.dart'; // Import the file where FoodItem is defined
import 'package:fridgemasters/Services/storage_service.dart'; // Import StorageService

class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  late Future<List<Recipe>> recipesFuture;

  @override
  void initState() {
    super.initState();
    recipesFuture = fetchInventoryAndRecipes();
  }

  Future<List<Recipe>> fetchInventoryAndRecipes() async {
    List<FoodItem> fridgeItems = await fetchInventoryItems();
    String ingredientNames = getFridgeItemNames(fridgeItems);
    return fetchRecipes(ingredientNames);
  }

  Future<List<FoodItem>> fetchInventoryItems() async {
  final storageService = StorageService(); // Assuming StorageService is used to retrieve the user ID
  final userId = await storageService.getStoredUserId(); // Retrieve the user ID

  if (userId == null || userId.isEmpty) {
    print("UserID is missing or empty.");
    return [];
  }

  final response = await http.post(
    Uri.parse('http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/get_user_inventory.php'),
    body: {
      'userId': userId, // Send the user ID as part of the POST request body
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((item) => FoodItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load inventory items');
  }
}

 String getFridgeItemNames(List<FoodItem> fridgeItems) {
  List<String> itemNames = fridgeItems.map((item) => item.name).toList();
  return Uri.encodeComponent(itemNames.join(',')); // Concatenate item names with commas
}

  Future<List<Recipe>> fetchRecipes(String ingredients) async {
    final String appIdRecipes = dotenv.env['EDAMAM_APP_ID_RECIPIES'] ?? "default_id";
    final String appKeyRecipes = dotenv.env['EDAMAM_APP_KEY_RECIPIES'] ?? "default_key";
    final String appUrlRecipes = dotenv.env['EDAMAM_APP_URL_RECIPIES'] ?? "default_url";

    final String url = '$appUrlRecipes?type=public&q=$ingredients&app_id=$appIdRecipes&app_key=$appKeyRecipes';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Recipe> recipes = (data['hits'] as List).map((hit) {
        return Recipe.fromJson(hit['recipe']);
      }).toList();
      return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
       title: Text('Recipes Page',style: GoogleFonts.calligraffitti(fontSize: 24.0,
      fontWeight: FontWeight.bold,),
        
        ),
        backgroundColor: theme.primaryColor,
      ),
      body: FutureBuilder<List<Recipe>>(
        future: recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return ListTile(
                  title: Text(recipe.label),
                  leading: Image.network(recipe.imageUrl),
                  onTap: () {
                    // Navigate to the RecipeInstructions page with the selected recipe
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RecipeInstructions(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Example destination page for a recipe details screen
