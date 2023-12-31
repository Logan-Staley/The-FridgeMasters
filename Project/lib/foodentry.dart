import 'dart:convert';
import 'package:fridgemasters/ExpiryLog.dart';
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
import 'package:fridgemasters/InventoryLog.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

//Michael Ndudim
class Recipe {
  final String uri;
  final String label;
  final String imageUrl;
  final String source;
  final String url;
  final List<String> ingredientLines;
  final Map<String, dynamic> totalNutrients;

//Michael Ndudim
  Recipe({
    required this.uri,
    required this.label,
    required this.imageUrl,
    required this.source,
    required this.url,
    required this.ingredientLines,
    required this.totalNutrients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      uri: json['uri'] ?? '',
      label: json['label'] ?? '',
      imageUrl: json['image'] ?? '',
      source: json['source'] ?? '',
      url: json['url'] ?? '',
      ingredientLines: List<String>.from(json['ingredientLines'] ?? []),
      totalNutrients: json['totalNutrients'] as Map<String, dynamic>,
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
  
  bool _isButtonActive = true;
  String _productName = '';
  String _imageUrl = '';
void enableButton() {
  setState(() {
    _isButtonActive = true;
  });
}
  Map<String, dynamic> _nutrientsInfo = {};
  List<Recipe> _recipes = [];

  // Make processEdamamData asynchronous and return a Future
  Future<void> processEdamamData(Map<String, dynamic> data,
      {bool isUpc = false}) async {
    String imageUrl = '';
    if (data.containsKey('hints') &&
        data['hints'] is List &&
        data['hints'].isNotEmpty) {
      Map<String, dynamic> firstHint = data['hints'][0];
      if (firstHint.containsKey('food') && firstHint['food'] is Map) {
        Map<String, dynamic> foodData = firstHint['food'];
        // Check for the existence of 'image' key and set imageUrl accordingly
        imageUrl = foodData.containsKey('image') ? foodData['image'] : '';
      }
    }

    String productName = '';
    if (isUpc) {
      // Check if the hints array is not empty and then access the label
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
      // If the call was not made with a UPC code, use the user input
      productName = foodItemNameController.text;
    }

// Initialize a variable to hold the nutrients data
    Map<String, dynamic> nutrients = {};

    // Determine if we should look in 'parsed' or 'hints'. If 'parsed' is empty, use 'hints'.
    var foodInfoList =
        (data['parsed'] as List).isNotEmpty ? data['parsed'] : data['hints'];

    // Check if the list is not empty and then access the 'nutrients' from the first 'food' object
    if (foodInfoList.isNotEmpty) {
      var foodData = foodInfoList[0]['food'];
      if (foodData != null && foodData.containsKey('nutrients')) {
        nutrients = foodData['nutrients'];
      }
    }

    // Call saveToInventory with the extracted data
    saveToInventory(productName: productName, imageUrl: imageUrl);
    // Extracting nutritional information
    //Map<String, dynamic> nutrients = data['nutrients'] ?? {};

    // Extracting recipes
    List<dynamic> recipes = data['hits'] ?? [];

    // Update your state with the fetched information
    //Logan S
//Michael Ndudim
    setState(() {
      if (foodItemNameController.text.isEmpty) {
        _productName = productName;
        print(productName);
      } else
        _productName = foodItemNameController.text;
      print(productName);
      _imageUrl = imageUrl; // Set the product name in the state
      _nutrientsInfo = nutrients;
      print(_nutrientsInfo);
      //_recipes = recipes.map((recipe) => Recipe.fromMap(recipe['recipe'])).toList();
    });
  }

//Michael Ndudim
  Future<bool> fetchFromEdamam(String foodName, {bool isUpc = false}) async {
    // Access the variables from .env file
    final String appIdFood = dotenv.env['EDAMAM_APP_FOOD'] ?? "default_id";
    final String appKeyFood =
        dotenv.env['EDAMAM_APP_KEY_FOOD'] ?? "default_key";
    final String appUrlFood =
        dotenv.env['EDAMAM_APP_URL_FOOD'] ?? "default_url";

    final String upcCode = upcNumberController.text;
    final String edamamUrlFood;

    if (upcCode.isNotEmpty) {
      edamamUrlFood =
          "$appUrlFood?upc=$upcCode&app_id=$appIdFood&app_key=$appKeyFood";
    } else {
      edamamUrlFood =
          "$appUrlFood?ingr=$foodName&app_id=$appIdFood&app_key=$appKeyFood";
    }
    // Use the edamamUrlFood to fetch food data...
    print("Edamam URL: $edamamUrlFood");

    // ... And similarly for Recipes

     try {
    final response = await http.get(Uri.parse(edamamUrlFood));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if(data.isEmpty || (isUpc && data['hints'].isEmpty)) {
        return false; // No data found for the UPC code
      }
      await processEdamamData(data, isUpc: isUpc);
      return true;
    } else {
      print("Failed to load data from Edamam: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Error fetching data from Edamam: $e");
    return false;
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

@override
  void initState() {
    super.initState();
    upcNumberController.addListener(_updateFieldState);
    foodItemNameController.addListener(_updateFieldState);
  }

  void _updateFieldState() {
  setState(() {
    // This will trigger a rebuild of the widget
  });
}

  @override
  void dispose() {
    upcNumberController.removeListener(_updateFieldState);
    upcNumberController.dispose();
    foodItemNameController.removeListener(_updateFieldState);
    foodItemNameController.dispose();
    // Dispose of other controllers if needed
    super.dispose();
  }


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

//Logan S - SavetoInventory
//Michael Ndudim -SavetoInventory
// ... [Other parts of the FoodEntry class]

  void saveToInventory(
      {required String productName, required String imageUrl}) async {
    void resetEntryState() {
      setState(() {
        _productName = '';
        _imageUrl = '';
        _nutrientsInfo = {};
        // Reset any other relevant state variables here
      });
    }

    final formattedDateOfPurchase =
        formatDateString(dateOfPurchaseController.text);
    final formattedExpirationDate =
        formatDateString(expirationDateController.text);

    final storageService = StorageService();
    final userId = await storageService.getStoredUserId();

    if (userId == null || userId.isEmpty) {
      print("UserID is missing or empty.");
      return;
    }

    productName = foodItemNameController.text.isEmpty
        ? productName
        : foodItemNameController.text;

    final response = await http.post(
      Uri.parse(
          'http://ec2-3-141-170-74.us-east-2.compute.amazonaws.com/insert_inventory.php'),
      body: {
        'productName': productName,
        'quantity': quantityController.text,
        'dateOfPurchase': formattedDateOfPurchase,
        'expirationDate': formattedExpirationDate,
        'userId': userId,
        'imageUrl': imageUrl,
        'nutritionalData': json.encode(
            _nutrientsInfo), // Send the nutritional data as a JSON string
        // Include any other data you need to send
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null && responseData['success'] != null) {
        final itemId = responseData['itemId'];
        final imageUrl = responseData['imageUrl'];
        final nutrientsData =
            _nutrientsInfo; // Using the state variable _nutrientsInfo
        print("Nutrients Info: $_nutrientsInfo");
ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
        // Create a FoodItem with the retrieved itemId and nutrients data
        final foodItem = FoodItem(
          itemId: itemId.toString(),
          name: foodItemNameController.text,
          quantity: int.tryParse(quantityController.text) ?? 0,
          dateOfPurchase: formattedDateOfPurchase,
          expirationDate: formattedExpirationDate,
          imageUrl: imageUrl,
          nutrients: nutrientsData,
        );

        print("Data sent successfully!");
        widget.onFoodItemAdded(foodItem);

        // After successful addition, log the item details
        await _logFoodItem(foodItem);
      } else {
        print("Error adding item: ${responseData['error']}");
      }
    } else {
      print("Error sending data: ${response.statusCode}");
    }

    foodItemNameController.clear();
    resetEntryState();
  }

  Future<void> _logFoodItem(FoodItem foodItem) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/inventory_log1.txt');

    String logEntry =
        'Food Item Added: ${foodItem.name}, Quantity: ${foodItem.quantity}, Date of Purchase: ${foodItem.dateOfPurchase}, Expiration Date: ${foodItem.expirationDate}, Timestamp: ${DateTime.now()}\n';
    await file.writeAsString(logEntry, mode: FileMode.append);
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
                upcNumberController.clear();
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Add to Inventory',
          style: GoogleFonts.calligraffitti(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: Taskbar(
        currentIndex: 1, // Assuming this is the second tab
        //backgroundColor: Color.fromARGB(255, 233, 232, 232),
        backgroundColor: theme.bottomAppBarColor,
        onTabChanged: (index) {
          currentIndex:
          0; // Handle tab change if necessary
        },
        // If you don't need food item addition functionality in this page, you can remove this callback or make it optional in the Taskbar widget
        onFoodItemAdded: (foodItem) {
          // Handle food item addition if required
        },
      ),
      body: SingleChildScrollView(
        child: Stack(
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
                      Row(
                        // Use Row to place buttons side by side
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center-align the buttons horizontally
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InventoryLog())); // Navigate to InventoryLog
                            },
                            child: Text(
                              'View Inventory Log',
                              style: TextStyle(
                                  fontSize: 16), // Increase button text size
                            ),
                          ),
                          SizedBox(
                              width:
                                  20), // Add some spacing between the buttons
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ExpiryLog())); // Navigate to InventoryLog
                            },
                            child: Text(
                              'View Expired Items',
                              style: TextStyle(
                                  fontSize: 16), // Increase button text size
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height:
                              20), // Add spacing between buttons row and text
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
                    enabled: foodItemNameController.text.isEmpty, // Disable if Name field is filled
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
                    enabled: upcNumberController.text.isEmpty, // Disable if UPC field is filled
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
  onPressed: () async {
    if (!_isButtonActive) {
      return; // If the button is inactive, don't perform any action
    }

    setState(() {
      _isButtonActive = false; // Disable the button
    });

    // Your existing button functionality goes here
   

    
    // Check if both UPC code and Name fields are filled
    if (upcNumberController.text.isNotEmpty && foodItemNameController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill either the UPC code or the Name field, not both.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  enableButton();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Stop further execution
    } else if (upcNumberController.text.isEmpty && foodItemNameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter a UPC code or a food name.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  enableButton();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Stop further execution
    }

    // Check if the Quantity field is empty or non-numeric
    if (quantityController.text.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(quantityController.text)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a valid number for quantity.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  enableButton();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Stop further execution
    }

    // Check if the Date of Purchase field is not empty
    if (dateOfPurchaseController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Missing Information'),
            content: const Text('Please enter the Date of Purchase.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  enableButton();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Do not proceed further if the field is empty
    }

    // Check if the Expiration Date field is not empty
    if (expirationDateController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Missing Information'),
            content: const Text('Please enter the Expiration Date.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  enableButton();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Do not proceed further if the field is empty
    }

    bool result = false;
    if (upcNumberController.text.isNotEmpty) {
      // Fetch data for UPC
      result = await fetchFromEdamam(upcNumberController.text, isUpc: true);
    } else {
      // Fetch data for food item name
      result = await fetchFromEdamam(foodItemNameController.text);
    }

    if (!result) {
      // Show an error message if data not found
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No data found for the entered information.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  enableButton();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Do not proceed further if no data is found
    }

    

  
    // Optional delay (if needed)
    await Future.delayed(Duration(seconds: 1));

    // Navigate back to the home tab
    Navigator.pushReplacementNamed(context, '/home');
    // Optional: Re-enable the button after some time
    await Future.delayed(Duration(seconds: 2)); // 2 seconds delay
    setState(() {
      _isButtonActive = true; // Re-enable the button
    });
  
  },
  
  child: const Text('Add to Fridge'),
),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context)
                          .colorScheme
                          .secondary, // Use the secondary color from the theme
                      onPrimary: Colors.white, // Text color
                      //shape: RoundedRectangleBorder(
                      //borderRadius: BorderRadius.circular(30), // Match the border radius
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
