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

class FoodEntry extends StatefulWidget {
  final Function(FoodItem) onFoodItemAdded;
  const FoodEntry({super.key, required this.onFoodItemAdded});

  @override
  _FoodEntryState createState() => _FoodEntryState();
}
Future<List<String>> fetchAutocompleteSuggestions(String query) async {
  final response = await http.get(
    Uri.parse('https://api.edamam.com/auto-complete=${query}&app_id=68dddfcc&app_key=3da64a21932f13c170c859806396e97e'),
  );

  if (response.statusCode == 200) {
    return List<String>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to fetch autocomplete suggestions.');
  }
}

class _FoodEntryState extends State<FoodEntry> {
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
          currentIndex: 0;// Handle tab change if necessary
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
                const Text('Food Item'),
                Autocomplete<String>(
  optionsBuilder: (TextEditingValue textEditingValue) {
    if (textEditingValue.text == '') {
      return const [];
    }
    // The function to fetch autocomplete suggestions should be synchronous.
    // So, consider changing the function or using a FutureBuilder or some other method.
    return fetchAutocompleteSuggestions(textEditingValue.text);
  },
  onSelected: (String selection) {
    foodItemNameController.text = selection;
  },
  optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (BuildContext context, int index) {
            final String option = options.elementAt(index);
            return GestureDetector(
              onTap: () {
                onSelected(option);
              },
              child: ListTile(
                title: Text(option),
              ),
            );
          },
        ),
      ),
    );
  },
  fieldViewBuilder: (BuildContext context, TextEditingController _textEditingController, FocusNode _focusNode, VoidCallback onFieldSubmitted) {
    return TextField(
      controller: foodItemNameController,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Ex: Strawberries, Milk, Cheese',
      ),
    );
  },
),

                const SizedBox(height: 20),
                const Text('Quantity'),
                InputTextBox(
                  isPassword: false,
                  hint: 'Ex: 20',
                  controller: quantityController,
                ),
                const SizedBox(height: 20),
                const Text('Date of Purchase'),
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
                const Text('Expiration Date'),
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
  }
}
