import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fridgemasters/inventory.dart';
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:fridgemasters/nutritionpage.dart';
import 'package:fridgemasters/widgets/textonlybutton.dart';
import 'package:fridgemasters/settings.dart';
import 'package:fridgemasters/notificationlist.dart';
import 'package:fridgemasters/foodentry.dart'; // Import the food entry page
import 'package:fridgemasters/Services/database_service.dart';
import 'package:fridgemasters/Services/storage_service.dart';
import 'package:fridgemasters/Services/deleteitem.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:uuid/uuid.dart';

String convertToDisplayFormat(String date) {
  var parts = date.split('-');
  if (parts.length == 3) {
    return '${parts[1]}/${parts[2]}/${parts[0]}'; // Convert to MM/DD/YYYY
  }
  return date; // Return the original string if the format isn't as expected
}


class ExpiringItemTile extends StatefulWidget {
  final String expirationDate;
  final String purchaseDate;
  final Widget child;

  ExpiringItemTile({
    required this.expirationDate,
    required this.purchaseDate,
    required this.child,
  });

  @override
  _ExpiringItemTileState createState() => _ExpiringItemTileState();
}

class _ExpiringItemTileState extends State<ExpiringItemTile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _nonExpiringBorder(Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 20, 220, 27), width: 2.0),
      ),
      child: child,
    );
  }

  Widget _closeToExpiringBorder(Widget child) {
  return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        final color = ColorTween(
          begin: Colors.yellow,
          end: Color.fromARGB(255, 103, 98, 30),
        ).lerp(_animationController.value);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: color!, width: 2.0),
          ),
          child: child,
        );
      },
    );
  }
 Widget _expiredBorder(Widget child) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        final color = ColorTween(
          begin: Color.fromARGB(255, 177, 21, 21),
          end: Color.fromARGB(255, 103, 98, 30),
        ).lerp(_animationController.value);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: color!, width: 2.0),
          ),
          child: child,
        );
      },
    );
  }

  Widget _getExpirationBorder(String expirationDate, String purchaseDate, Widget child) {
    final expiryDate = DateTime.parse(expirationDate);
    final currentDate = DateTime.now();
    final currentDateAtMidnight = DateTime(currentDate.year, currentDate.month, currentDate.day);
    final purchaseDateParsed = DateTime.parse(purchaseDate);
    final daysLeft = expiryDate.difference(currentDateAtMidnight).inDays;

    if (expiryDate.isBefore(currentDateAtMidnight) || expiryDate.isBefore(purchaseDateParsed)) {
      return _expiredBorder(child);
    } else if (daysLeft <= 7) {
      return _closeToExpiringBorder(child);
    } else {
      return _nonExpiringBorder(child);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getExpirationBorder(widget.expirationDate, widget.purchaseDate, widget.child);
  }
}

class YourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get today's date
    String currentDate = DateTime.now().toString().split(' ')[0]; // YYYY-MM-DD format

    return Column(
      children: [
        // Today's Date Centered
        Text(
          'Today\'s Date: $currentDate',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10), // Spacing

        // Legend
      ],
    );
  }
}

class HomePage extends StatefulWidget {

  
  final List<Map<String, dynamic>> fridgeItems;

  const HomePage({Key? key, required this.fridgeItems}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> fridgeItems = [];
  final TextEditingController _searchController = TextEditingController();
  final DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadFridgeItems();
  }

  void _loadFridgeItems() async {
    try {
      final storageService = StorageService();

      // Fetch stored userId from storage
      String? userID = await storageService.getStoredUserId();

      if (userID != null) {
        List<Map<String, dynamic>> loadedItems =
            await dbService.getUserInventory(userID);

// Map the loadedItems to the expected format
        List<Map<String, dynamic>> formattedItems = loadedItems.map((item) {
          return {
            'itemId': item['itemId'], // Include the itemId
            'name': item['productName'],
            'quantity': '${item['quantity']}',
            'purchaseDate': item['dateOfPurchase']
                .split(" ")[0], // Only take the date part, exclude the time
            'expirationDate': item['expirationDate']
                .split(" ")[0], // Only take the date part, exclude the time

            'imageUrl':
                'images/default_image.png', // Keep as default or adjust as necessary
          };
        }).toList();
print('Formatted Items: $formattedItems'); // Print the formattedItems list
        setState(() {
          widget.fridgeItems.addAll(formattedItems);
        });
      } else {
        print('No user ID found in storage.');
      }
    } catch (error) {
      print('Error fetching items: $error');
      // Handle any errors, maybe show a notification to the user
    }
  }

  void _navigateToAddItem() async {
    final FoodItem? newFoodItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodEntry(onFoodItemAdded: (foodItem) {
          Navigator.pop(
              context, foodItem); // Return the food item back to this page
        }),
      ),
    );

    if (newFoodItem != null) {
      setState(() {
        widget.fridgeItems.add({
          'ItemID': newFoodItem.itemId,
          'name': newFoodItem.name,
          'quantity': '${newFoodItem.quantity}',
          'purchaseDate': newFoodItem.dateOfPurchase.toString(),
          'expirationDate': newFoodItem.expirationDate.toString(),
          'imageUrl':
              'images/default_image.png',
        });
      });
    }
  }

 Color _getExpirationColor(String expirationDate, String purchaseDate) {
  final expiryDate = DateTime.parse(expirationDate);
  final currentDate = DateTime.now();
  final currentDateAtMidnight = DateTime(currentDate.year, currentDate.month, currentDate.day);
  final purchaseDateParsed = DateTime.parse(purchaseDate);
  final daysLeft = expiryDate.difference(currentDateAtMidnight).inDays;

  // Condition 1: If the expiration date is before the current date.
  if (expiryDate.isBefore(currentDateAtMidnight)) {
    return Color.fromARGB(255, 177, 21, 21);
  } 
  // Condition 2: If the expiration date is before the purchase date.
  else if (expiryDate.isBefore(purchaseDateParsed)) {
    return Color.fromARGB(255, 177, 21, 21);
  }
  else if (daysLeft <= 7) {
    return Colors.yellow;
  } else {
    return Color.fromARGB(255, 20, 220, 27);
  }
}

Widget _nonExpiringBorder(Widget child) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromARGB(255, 20, 220, 27), width: 2.0),
    ),
    child: child,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(220, 48, 141, 160),
        elevation: 0, // Removes the default shadow
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: const Color.fromARGB(255, 215, 215, 215),
              width: 2), // Blue border
        ),
        
        leading: IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationList(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Filter based on food items',
                border: OutlineInputBorder(
                  //backgroundColor: color.Yellow,
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const Background(type: 'Background1'),
          Center(
              child: widget.fridgeItems.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Add Items to your fridge!'),
                        Icon(Icons.arrow_downward, color: Colors.red),
                      ],
                    )
                  : ListView.builder(
                      itemCount: widget.fridgeItems.length + 1, // +1 for the header (date and legend)
                      
  itemBuilder: (context, index) {
    
    // This is for the header, which contains the date and legend
    if (index == 0) {
      return Column(
  children: [
    SizedBox(height: 10),
    Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Today\'s Date: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
            ),
            TextSpan(
              text:
                  '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
    SizedBox(height: 5),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Expiry Legend: ',
                    style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold), 
                  ),
                  TextSpan(
                    text: '🟡',
                    style: TextStyle(color: Color.fromARGB(255, 4, 114, 8), fontSize: 17, fontWeight: FontWeight.bold), 
                  ),
                  TextSpan(
                    text: ' - Safe to Eat (>1wk) | ',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16, fontWeight: FontWeight.bold), 
                  ),
                  TextSpan(
                    text: '🟡',
                    style: TextStyle(color: Color.fromARGB(255, 250, 228, 28), fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' - Nearing Expiry (≤1wk) | ',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16, fontWeight: FontWeight.bold), 
                  ),
                  TextSpan(
                    text: '🟡',
                    style: TextStyle(color: Color.fromARGB(255, 226, 50, 50), fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' - Expired',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16, fontWeight: FontWeight.bold), 
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      );
    } else {
      // Index is greater than 0, so it's an item
                        final item = widget.fridgeItems[index-1];
                        final itemId = item['itemId'];
                        print('Item ID at index $index: $itemId');
                        Color _getPastelColor(int index) {
                          final r = (70 + (index * 50) % 135).toDouble();
                          final g = (90 + (index * 80) % 85).toDouble();
                          final b = (120 + (index * 30) % 55).toDouble();
                          return Color.fromRGBO(
                              r.toInt(), g.toInt(), b.toInt(), 0.9);
                        }

                       
                           return Padding(
  padding: const EdgeInsets.all(8.0),
  child: Card(
    color: _getPastelColor(index),
    elevation: 4.0, // Added shadow
    child:  ExpiringItemTile(
      expirationDate: item['expirationDate'],
      purchaseDate: item['purchaseDate'],
      child: Container(
                              height: 137,
                              child: Stack(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              16.0), // Image padding
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.brown,
                                                  width: 3),
                                              image: DecorationImage(
                                                image: NetworkImage(item[
                                                        'imageUrl'] ??
                                                    'images/default_image.png'), // Explicit Null Check for imageUrl
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Center(
                                                      child: RichText(
                                                        textAlign:
                                                            TextAlign.center,
                                                        text: TextSpan(
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: 'Name: ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        12)), // Descriptor size
                                                            TextSpan(
                                                                text:
                                                                    '${item['name']}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),decoration: TextDecoration.underline)), // User-entered text size
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    'Purchased: ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                            TextSpan(
                                                                text: convertToDisplayFormat(
                                                                    item[
                                                                        'purchaseDate']),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255))),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Center(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: 'Qty: ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                            TextSpan(
                                                                text:
                                                                    '${item['quantity']}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17.5,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255))),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    'Expiry: ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                            TextSpan(
                                                              text: convertToDisplayFormat(
                                                                  item[
                                                                      'expirationDate']),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17,
                                                                color: _getExpirationColor(item['expirationDate'], item['purchaseDate'])

                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 5, // adjust as needed
                                    left: 30, // adjust as needed
                                    child: Text(
                                      'Click Image for Nutritional Insights!', // replace with dynamic data if needed
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 255, 255,
                                            255), // or any color you prefer
                                      ),
                                    ),
                                  ),
                                   Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.delete, size: 20),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            bool isChecked = false;
                                            return AlertDialog(
                                              title: Text('Delete Item'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      'Are you sure you want to delete this item?'),
                                                  Row(
                                                    children: [
                                                      Checkbox(
                                                        value: isChecked,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            isChecked = value!;
                                                          });
                                                        },
                                                      ),
                                                      Text("This has expired"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    final currentItem = widget
                                                        .fridgeItems[index-1];
                                                   try {
  final StorageService storageService = StorageService();
  String? userID = await storageService.getStoredUserId();
  
  if (userID != null) {
    String itemIdString = itemId.toString();
    await deleteItem(userID, itemIdString);
    
    // If the deletion was successful in the backend, remove from the local list
    setState(() {
      widget.fridgeItems.removeAt(index-1);
    });
  } else {
    // Handle the case where userID is null, e.g., show an error message
    print("User ID is null");
  }
}  catch (e) {
                                                      print(
                                                          "Error deleting item: $e");
                                                      // Here you can show some error message or handle it as per your needs
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                           )
                         );
    }
                      },
                    )),
        ],
      ),
      bottomNavigationBar: Taskbar(
        currentIndex: 0,
        backgroundColor: Color.fromARGB(255, 233, 232, 232),
        onTabChanged: (index) {},
        onFoodItemAdded: (foodItem) {
          // You need to provide this callback
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItem,
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(210, 33, 149, 243),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


