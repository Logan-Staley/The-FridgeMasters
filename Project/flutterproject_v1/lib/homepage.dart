import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:fridgemasters/nutritionpage.dart'; // Replace with the actual path to nutritionpage.dart
import 'package:fridgemasters/widgets/textonlybutton.dart'; // Replace with the actual path to textonlybutton.dart

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
          // ... (rest of your code)
          ),
      body: Stack(
        children: [
          const Background1(),
          Center(
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fridgeItems.length,
                itemBuilder: (context, index) {
                  final item = fridgeItems[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: SizedBox(
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${item['name']}'),
                              Text(
                                  'Expiration Date: ${item['expirationDate']}'),
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
                    ),
                  );
                },
              ),
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
