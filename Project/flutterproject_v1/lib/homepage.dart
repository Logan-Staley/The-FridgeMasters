import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:fridgemasters/nutritionpage.dart'; // Replace with the actual path to nutritionpage.dart
import 'package:fridgemasters/widgets/textonlybutton.dart'; // Replace with the actual path to textonlybutton.dart
import 'package:fridgemasters/settings.dart'; // Replace with the actual path to settings.dart
import 'package:fridgemasters/notificationlist.dart'; // Replace with the actual path to notificationlist.dart

class HomePage extends StatelessWidget {
  // Sample data for fridge items
  final List<Map<String, dynamic>> fridgeItems = List.generate(
    20,
    (index) => {
      'name': 'Item $index',
      'expirationDate': '2023-10-${10 + index}',
      'quantity': '${index + 1} liter',
      'purchaseDate': '2023-09-${10 + index}'
    },
  );

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Added leading and actions for Notifications and Settings buttons
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
      ),
      body: Stack(
        children: [
          const Background1(),
          Center(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: fridgeItems.length,
              itemBuilder: (context, index) {
                final item = fridgeItems[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${item['name']}'),
                          Text('Expiration Date: ${item['expirationDate']}'),
                          Text('Quantity: ${item['quantity']}'),
                          Text('Purchase Date: ${item['purchaseDate']}'),
                          TextOnlyButton(
                            text: 'Nutrition Facts',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NutritionPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Taskbar(
        currentIndex: 0,
        onTabChanged: (index) {},
      ),
    );
  }
}
