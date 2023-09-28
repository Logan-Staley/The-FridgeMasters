import 'package:flutter/material.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  // Sample list of food items that are expiring
  List<String> foodItems = [
    'Milk expires in 2 days',
    'Bread expires tomorrow',
    'Cheese expires in 5 days',
    'Yogurt expires in 1 day',
    'Eggs expire in 3 days'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(foodItems[index]),
            trailing: ElevatedButton(
              onPressed: () {
                // Remove the item from the list
                setState(() {
                  foodItems.removeAt(index);
                });
              },
              child: Text('Dismiss'),
            ),
          );
        },
      ),
    );
  }
}
