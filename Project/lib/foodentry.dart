import 'dart:convert';
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

class _FoodEntryState extends State<FoodEntry> {

  
  String _imageUrl = '';
  Map<String, dynamic> _nutrientsInfo = {};
  List<Recipe> _recipes = [];

  void processEdamamData(Map<String, dynamic> data) {
    // Extracting image URL
    String imageUrl = data['image'] ?? '';
    
    // Extracting nutritional information
    Map<String, dynamic> nutrients = data['nutrients'] ?? {};
    
    // Extracting recipes
    List<dynamic> recipes = data['hits'] ?? [];

    // Update your state with the fetched information
    setState(() {
      _imageUrl = imageUrl;
      _nutrientsInfo = nutrients;
      _recipes = recipes.map((recipe) => Recipe.fromMap(recipe['recipe'])).toList();
    });
  }


  Future<void> fetchFromEdamam(String foodName) async {
  // Access the variables from .env file
  final String appIdFood = dotenv.env['EDAMAM_APP_FOOD'] ?? "default_id";
  final String appKeyFood = dotenv.env['EDAMAM_APP_KEY_FOOD'] ?? "default_key";
  final String appUrlFood = dotenv.env['EDAMAM_APP_URL_FOOD'] ?? "default_url";

  final String edamamUrlFood = "$appUrlFood?ingr=$foodName&app_id=$appIdFood&app_key=$appKeyFood";

  // Use the edamamUrlFood to fetch food data...

  // You can do the same for Nutrition and Recipes
  final String appIdNutrition = dotenv.env['EDAMAM_APP_NUTRITION'] ?? "default_id";
  final String appKeyNutrition = dotenv.env['EDAMAM_APP_KEY_NUTRITION'] ?? "default_key";
  final String appUrlNutrition = dotenv.env['EDAMAM_APP_URL_NUTRITION'] ?? "default_url";

  // ... And similarly for Recipes
  final String appIdRecipes = dotenv.env['EDAMAM_APP_ID_RECIPIES'] ?? "default_id";
  final String appKeyRecipes = dotenv.env['EDAMAM_APP_KEY_RECIPIES'] ?? "default_key";
  final String appUrlRecipes = dotenv.env['EDAMAM_APP_URL_RECIPIES'] ?? "default_url";

  // Make sure to use the correct URL depending on what type of data you're fetching
  // For example, if you're fetching food information, use edamamUrlFood
  // If you're fetching nutrition information, use the appropriate URL and keys
  // And the same goes for recipes


  try {
    final response = await http.get(Uri.parse(edamamUrlFood));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Assuming you have a method to process this data
      processEdamamData(data);
    } else {
      print("Failed to load data from Edamam: ${response.body}");
    }
  } catch (e) {
    print("Error fetching data from Edamam: $e");
  }
}
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

  if (pickedDate != null) {
    controller.text = DateFormat('MM/dd/yyyy').format(pickedDate);
  }
}
  TextEditingController upcNumberController = TextEditingController();
  TextEditingController ItemID = TextEditingController();
  TextEditingController foodItemNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController dateOfPurchaseController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();

  String formatDateString(String dateStr) {
    try {
      DateFormat inputFormat = DateFormat("MM/dd/yyyy");
      DateTime date = inputFormat.parse(dateStr);
      DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      return outputFormat.format(date);
    } catch (e) {
      print('Error parsing date: $e');
      return '';
    }
  }

void saveToInventory() async {
  final formattedDateOfPurchase = formatDateString(dateOfPurchaseController.text);
  final formattedExpirationDate = formatDateString(expirationDateController.text);

  // Retrieve the userID from storage
  final storageService = StorageService();
  final userId = await storageService.getStoredUserId();

  // Make sure you have a valid userID before sending the data
  if (userId == null || userId.isEmpty) {
    print("UserID is missing or empty.");
    return;
  }
 // Get the itemId from the ItemID controller
  final itemId = ItemID.text;
  // HTTP request
  final response = await http.post(
    Uri.parse('http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/insert_inventory.php'),
    body: {
      'itemID': itemId,
      'productName': foodItemNameController.text,
      'quantity': quantityController.text,
      'dateOfPurchase': formattedDateOfPurchase,
      'expirationDate': formattedExpirationDate,
      'userId': userId, // Include the userID in the request
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final itemId = responseData['itemId']; // Get the itemId from the response
    print('Item ID: $itemId');
    // Create a FoodItem with the retrieved itemId
    final foodItem = FoodItem(
      itemId: itemId.toString(), // Convert to string if necessary
      name: foodItemNameController.text,
      quantity: int.tryParse(quantityController.text) ?? 0,
      dateOfPurchase: formattedDateOfPurchase,
      expirationDate: formattedExpirationDate,
    );

    print("Data sent successfully!");
    print(itemId);
    widget.onFoodItemAdded(foodItem);
  } else {
    print("Error sending data: ${response.body}");
  }
}

  void clearFields() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to clear the fields?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                foodItemNameController.clear();
                quantityController.clear();
                dateOfPurchaseController.clear();
                expirationDateController.clear();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Add to Inventory'),
    ),
    bottomNavigationBar: Taskbar(
      currentIndex: 1, // Assuming this is the second tab
      backgroundColor: Color.fromARGB(255, 233, 232, 232),
      onTabChanged: (index) {
        currentIndex: 0; // Handle tab change if necessary
      },
      // If you don't need food item addition functionality in this page, you can remove this callback or make it optional in the Taskbar widget
      onFoodItemAdded: (foodItem) {
        // Handle food item addition if required
      },
    ),
    body: Stack(
      children: [
        Background(type: 'Background1'), // for Background1
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add spacing between buttons row and text
              SizedBox(height: 20),
              Column(
                children: [
                  Row( // Use Row to place buttons side by side
                    mainAxisAlignment: MainAxisAlignment.center, // Center-align the buttons horizontally
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle the "View Inventory Log" button click
                        },
                        child: Text(
                          'View Inventory Log',
                          style: TextStyle(fontSize: 16), // Increase button text size
                        ),
                      ),
                      SizedBox(width: 20), // Add some spacing between the buttons
                      ElevatedButton(
                        onPressed: () {
                          // Handle the "View Expired Items" button click
                        },
                        child: Text(
                          'View Expired Items',
                          style: TextStyle(fontSize: 16), // Increase button text size
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Add spacing between buttons row and text
                ],
              ),
              Text(
                'UPC Number (Optional)', // Label for UPC Number
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Make the text bold
                ),
              ),
              InputTextBox(
                isPassword: false,
                hint: 'Ex: 1234567890',
                controller: upcNumberController,
              ),
              const SizedBox(height: 20),
              Text(
                'Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              InputTextBox(
                isPassword: false,
                hint: 'Ex: Strawberries, Milk, Cheese',
                controller: foodItemNameController,
              ),
              const SizedBox(height: 20),
              Text(
                'Quantity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              InputTextBox(
                isPassword: false,
                hint: 'Ex: 20',
                controller: quantityController,
              ),
              const SizedBox(height: 20),
              Text(
                'Date of Purchase',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context, dateOfPurchaseController),
                child: AbsorbPointer(
                  child: InputTextBox(
                    isPassword: false,
                    hint: 'Ex: 12/21/2023',
                    controller: dateOfPurchaseController,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Expiration Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context, expirationDateController),
                child: AbsorbPointer(
                  child: InputTextBox(
                    isPassword: false,
                    hint: 'Ex: 12/21/2023',
                    controller: expirationDateController,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveToInventory,
                child: const Text('Add to Fridge'),
              ),
              const SizedBox(height: 20),
              TextOnlyButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}}