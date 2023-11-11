import 'package:flutter/material.dart';
import 'package:fridgemasters/Services/storage_service.dart';
import 'package:fridgemasters/Services/fetchinventoryitems.dart'; 
import 'package:fridgemasters/inventory.dart';// make sure to import your fetch function
import 'package:fridgemasters/Services/database_service.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<Map<String, dynamic>> expiredItems = [];
  final StorageService storageService = StorageService(); // Assuming you have this service set up
  final DatabaseService dbService = DatabaseService(); // Assuming you have this service set up

  @override
  void initState() {
    super.initState();
    _loadFridgeItems();
  }

  void _loadFridgeItems() async {
    // Fetch stored userId from storage
    String? userID = await storageService.getStoredUserId();

    if (userID != null) {
      try {
        List<Map<String, dynamic>> loadedItems =
            await dbService.getUserInventory(userID);

        // Filter out expired items and map them to a more usable format if necessary
        final currentDate = DateTime.now();
        final expired = loadedItems.where((item) {
          final expirationDate = DateTime.parse(item['expirationDate']);
          return expirationDate.isBefore(currentDate);
        }).toList();

        setState(() {
          expiredItems = expired;
        });
      } catch (error) {
        print('Error fetching items: $error');
        // Handle any errors, maybe show a notification to the user
      }
    } else {
      print('No user ID found in storage.');
      // Handle the case where the user ID is not found
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDateStr = '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Column(
        children: [
          // Display the current date
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Current Date: $currentDateStr',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Display the list of expired items
          Expanded(
            child: ListView.builder(
  itemCount: expiredItems.length,
  itemBuilder: (context, index) {
    final item = expiredItems[index];
    return ListTile(
      title: Text(item['productName']), // assuming the name is stored under the key 'productName'
      subtitle: Text('Expires on: ${item['expirationDate']}'), // the key is 'expirationDate'
      trailing: ElevatedButton(
        onPressed: () {
          // Logic to dismiss an item
        },
        child: Text('Dismiss'),
      ),
    );
  },
),
          ),
        ],
      ),
    );
  }
}