import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridgemasters/recipesinstructions.dart';
import 'package:http/http.dart' as http;
import 'foodentry.dart'; // Import the file where Recipe is defined
import 'dart:convert'; // Import json for decoding the response
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Make sure to include this package for .env access
import 'inventory.dart'; // Import the file where FoodItem is defined
import 'package:fridgemasters/Services/storage_service.dart'; // Import StorageService
import 'package:fridgemasters/Widgets/taskbar.dart';
class Recipes extends StatefulWidget {
  const Recipes({Key? key}) : super(key: key);

  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  List<FoodItem> fridgeItems = [];
  List<String> selectedIngredients = [];
  List<Recipe> recipes = [];
  bool isLoading = false; // Set this to false initially
  bool noRecipesFound = false; // Add this line
  TextEditingController searchController = TextEditingController(); // For the search bar
bool firstSearchAttempted = false; // New state variable to track the first search attempt
  @override
  void initState() {
    super.initState();
    // Start loading before initiating the fetch process
    setState(() {
      isLoading = true;
    });
    fetchInventoryItems().then((items) {
      setState(() {
        fridgeItems = items;
        // Stop loading only after the items are fetched
        isLoading = false;
      });
    }).catchError((error) {
      // Handle errors appropriately
      setState(() {
        isLoading = false;
        // Consider adding an error message state variable to display
      });
      print("Error fetching inventory: $error");
    });
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
    print('Fetched Fridge Items: $fridgeItems');

    return jsonResponse.map((item) => FoodItem.fromJson(item)).toList();
    
  } else {
    throw Exception('Failed to load inventory items');
  }
}

Future<void> fetchAndSetRecipes() async {
  setState(() {
    isLoading = true;  // Start loading only when fetching
  });

  try {
    String ingredientQuery = Uri.encodeComponent(selectedIngredients.join(','));
    List<Recipe> fetchedRecipes = await fetchRecipes(ingredientQuery);
    if (fetchedRecipes.isEmpty) {
      setState(() {
        recipes = [];
        isLoading = false;
        noRecipesFound = true; // Set to true if no recipes are found
      });
    } else {
      setState(() {
        recipes = fetchedRecipes;
        isLoading = false;
        noRecipesFound = false; // Set to false if recipes are found
      });
    }
  } catch (e) {
    setState(() {
      isLoading = false;
      noRecipesFound = true; // Set to true if an error occurs
    });
    print('Error fetching recipes: $e');
  }
}

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Filtered list based on the search text
    final filteredFridgeItems = fridgeItems
        .where((item) => item.name.toLowerCase().contains(searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes Page', style: GoogleFonts.calligraffitti(fontSize: 24.0, fontWeight: FontWeight.bold,)),
        backgroundColor: theme.primaryColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        'Select the Ingredients you would like to see recipes for OR',
        style: theme.textTheme.subtitle1,
        textAlign: TextAlign.center,
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search Ingredients',
          suffixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
          setState(() {
            // The list will be filtered by the ListView.builder
          });
        },
      ),
    ),
                
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: filteredFridgeItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredFridgeItems[index];
                      return Card(
                        elevation: 2.0,
                        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: CheckboxListTile(
                          title: Text(item.name),
                          value: selectedIngredients.contains(item.name),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedIngredients.add(item.name);
                              } else {
                                selectedIngredients.remove(item.name);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    fetchAndSetRecipes();
                  },
                  child: Text('Find Recipes'),
                ),
                Expanded(
  flex: 4,
  child: recipes.isEmpty && !isLoading
      ? Center(
          child: noRecipesFound
              ? Text('No Recipes Found')
              : firstSearchAttempted 
                  ? CircularProgressIndicator() 
                  : Text('Please Select Ingredients to generate Recipe Suggestions'), // Show this message initially
        )
      : ListView.builder(
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];
                            return Card(
                              elevation: 4.0,
                              child: ListTile(
                                title: Text(recipe.label),
                                leading: Image.network(recipe.imageUrl),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => RecipeInstructions(recipe: recipe),
                                    ),
                                  );
                                },
                              ),
                            );
                            
                          },
                        ),
                        
                ),
                
              ],
            ),
          bottomNavigationBar: Taskbar(
      currentIndex: 2, // Make sure this is managed based on the state
      backgroundColor: theme.bottomAppBarColor,
      onTabChanged: (index) {
        // Handle tab change logic here
      },
      onFoodItemAdded: (foodItem) {
        // Handle the action when a food item is added
      },
    ),
  );
}  
    
  
}