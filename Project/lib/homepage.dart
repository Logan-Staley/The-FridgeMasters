import 'package:flutter/material.dart';
import 'package:fridgemasters/inventory.dart';
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:fridgemasters/nutritionpage.dart';
import 'package:fridgemasters/widgets/textonlybutton.dart';
import 'package:fridgemasters/settings.dart';
import 'package:fridgemasters/notificationlist.dart';
import 'package:fridgemasters/foodentry.dart'; // Import the food entry page
import 'package:fridgemasters/database_service.dart';
import 'package:fridgemasters/Services/storage_service.dart';
import 'package:fridgemasters/Services/deleteitem.dart';

String convertToDisplayFormat(String date) {
    var parts = date.split('-');
    if (parts.length == 3) {
        return '${parts[1]}/${parts[2]}/${parts[0]}'; // Convert to MM/DD/YYYY
    }
    return date; // Return the original string if the format isn't as expected
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
      List<Map<String, dynamic>> loadedItems = await dbService.getUserInventory(userID);

// Map the loadedItems to the expected format
List<Map<String, dynamic>> formattedItems = loadedItems.map((item) {
  return {
    'name': item['productName'],
    'quantity': '${item['quantity']}',
'purchaseDate': item['dateOfPurchase'].split(" ")[0], // Only take the date part, exclude the time
'expirationDate': item['expirationDate'].split(" ")[0], // Only take the date part, exclude the time

    'imageUrl': 'data:image/png;base64,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', // Keep as default or adjust as necessary
  };
}).toList();

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
        Navigator.pop(context, foodItem); // Return the food item back to this page
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
              'data:image/png;base64,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',
        });
      });
    }
  }

  Color _getExpirationColor(String expirationDate) {
    final expiryDate = DateTime.parse(expirationDate);
    final currentDate = DateTime.now();
    final daysLeft = expiryDate.difference(currentDate).inDays;
    if (daysLeft < 0) {
      return Colors.red;
    } else if (daysLeft < 7) {
      return Colors.yellow;
    } else {
      return Color.fromARGB(255, 20, 220, 27);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(180, 160, 48, 48),
        elevation: 0,  // Removes the default shadow
      shape: RoundedRectangleBorder(
        side: BorderSide(color: const Color.fromARGB(255, 215, 215, 215), width: 2), // Blue border
        
        
           ),leading: IconButton(
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
          const Background1(),
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
  itemCount: widget.fridgeItems.length,
  itemBuilder: (context, index) {
    final item = widget.fridgeItems[index];

    Color _getPastelColor(int index) {
  final r = (70 + (index * 50) % 135).toDouble();
  final g = (90 + (index * 80) % 85).toDouble();
  final b = (120 + (index * 30) % 55).toDouble();
  return Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), 0.9); 
}


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: _getPastelColor(index),
        elevation: 4.0, // Added shadow
        child: Container(
          height: 137,
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // Image padding
                      child: Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.brown, width: 3),
    image: DecorationImage(
      image: NetworkImage(item['imageUrl'] ?? 'data:image/png;base64,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'), // Explicit Null Check for imageUrl
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
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: 'Name: ', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)), // Descriptor size
                TextSpan(text: '${item['name']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 145, 139, 138))), // User-entered text size
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(text: 'Purchased: ', style: TextStyle(fontWeight: FontWeight.normal)),
                                        TextSpan(text: convertToDisplayFormat(item['purchaseDate']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Color.fromARGB(255, 255, 255, 255))),
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
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(text: 'Qty: ', style: TextStyle(fontWeight: FontWeight.normal)),
                                        TextSpan(text: '${item['quantity']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 255, 255, 255))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(text: 'Expiry: ', style: TextStyle(fontWeight: FontWeight.normal)),
                                        TextSpan(
                                          text: convertToDisplayFormat(item['expirationDate']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: _getExpirationColor(item['expirationDate']),
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
      bottom: 10, // adjust as needed
      right: 10,   // adjust as needed
      child: Text(
        'Item Number: 5', // replace with dynamic data if needed
        style: TextStyle(
          fontSize: 12, 
          color: Colors.black, // or any color you prefer
        ),
      ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.delete, size: 26), 
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
                              Text('Are you sure you want to delete this item?'),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
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
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  widget.fridgeItems.removeAt(index);
                                });
                                Navigator.of(context).pop(); // Close the dialog
                                // Add logic to handle database update here
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
      ),
    );
  },
)

),
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
