import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:fridgemasters/notificationlist.dart';
import 'package:fridgemasters/settings.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationList()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Background1(),
          Center(
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fridgeItems.length,
                itemBuilder: (context, index) {
                  final item = fridgeItems[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailPage(item: item),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Container(
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
                              ],
                            ),
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

class ItemDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  ItemDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${item['name']}'),
            Text('Expiration Date: ${item['expirationDate']}'),
            Text('Quantity: ${item['quantity']}'),
            Text('Purchase Date: ${item['purchaseDate']}'),
          ],
        ),
      ),
    );
  }
}
