import 'package:flutter/material.dart';
import 'package:fridgemasters/inventory.dart';
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:fridgemasters/nutritionpage.dart';
import 'package:fridgemasters/widgets/textonlybutton.dart';
import 'package:fridgemasters/settings.dart';
import 'package:fridgemasters/notificationlist.dart';
import 'package:fridgemasters/foodentry.dart'; // Import the food entry page

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> fridgeItems;

  const HomePage({super.key, required this.fridgeItems});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> fridgeItems = [];
  final TextEditingController _searchController = TextEditingController();

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
        'name': newFoodItem.name,
        'quantity': '${newFoodItem.quantity} units',
        'purchaseDate': newFoodItem.dateOfPurchase.toString(),
        'expirationDate': newFoodItem.expirationDate.toString(),
        'imageUrl': 'default_url',
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
      return const Color.fromARGB(255, 35, 205, 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      final r = (100 + (index * 50) % 155).toDouble();
      final g = (150 + (index * 90) % 105).toDouble();
      final b = (200 + (index * 30) % 55).toDouble();
      return Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), 0.9); 
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: _getPastelColor(index),
        elevation: 4.0, // Added shadow
        child: Container(
          height: 180,
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
                          border: Border.all(color: Colors.brown, width: 3), // Increased border width
                          image: DecorationImage(
                            image: NetworkImage(item['imageUrl']),
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
                TextSpan(text: '${item['name']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 206, 55, 9))), // User-entered text size
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
                                        TextSpan(text: '${item['purchaseDate']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Color.fromARGB(255, 255, 255, 255))),
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
                                          text: '${item['expirationDate']}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: _getExpirationColor(item['expirationDate']),
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
        onTabChanged: (index) {},
        onFoodItemAdded: (foodItem) {
          // You need to provide this callback
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItem,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
