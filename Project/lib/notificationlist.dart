import 'package:flutter/material.dart';
import 'package:fridgemasters/cache/dismissednotifications.dart';
import 'package:fridgemasters/Services/deleteitem.dart'; // Import the deleteItem function
import 'package:fridgemasters/Services/storage_service.dart'; // Import StorageService
import 'package:intl/intl.dart';
import 'package:fridgemasters/widgets/backgrounds.dart'; // Import DateFormat for date formatting
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> _logItemDeletion(Map<String, dynamic> item) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final file = File('$path/inventory_log1.txt');

  String logEntry =
      'Deleted Item: ${item['name']}, Quantity: ${item['quantity']}, Expiration Date: ${item['expirationDate']}, Purchase Date: ${item['purchaseDate']}\n';

  try {
    await file.writeAsString(logEntry, mode: FileMode.append);
  } catch (e) {
    print('Error writing to log file: $e');
  }
}


class NotificationList extends StatefulWidget {
  final List<Map<String, dynamic>> fridgeItems;

  const NotificationList({Key? key, required this.fridgeItems})
      : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  late List<Map<String, dynamic>> fridgeItemsNotify;

  @override
  void initState() {
    super.initState();
    fridgeItemsNotify = List.from(widget.fridgeItems.where((item) {
      return !dismissednotices.contains(item['itemId']);
    }));
  }

 String _getExpirationStatus(Map<String, dynamic> item) {
    DateTime expirationDate = DateTime.parse(item['expirationDate']);
    DateTime currentDate = DateTime.now();

    if (currentDate.isAfter(expirationDate)) {
      // Item is expired
      return "${item['name']} is expired. Expired on: ${DateFormat('MM/dd/yyyy').format(expirationDate)}";
    } else if (currentDate.isBefore(expirationDate) &&
        currentDate.add(Duration(days: 3)).isAfter(expirationDate)) {
      // Item is about to expire
      return "${item['name']} is about to expire. Expires on: ${DateFormat('MM/dd/yyyy').format(expirationDate)}";
    } else {
      // For other cases, show the normal expiration date
      return "Expires on: ${DateFormat('MM/dd/yyyy').format(expirationDate)}";
    }
  }

  Future<void> _deleteItem(dynamic itemId) async {
    try {
      // Finding the item to delete, safely handling if it's not found
      final itemToDelete = fridgeItemsNotify.firstWhere(
        (item) => item['itemId'] == itemId,
        orElse: () =>
            <String, dynamic>{}, // Return an empty map instead of null
      );

      // Check if itemToDelete is not empty, implying an item was found
      if (itemToDelete.isNotEmpty) {
        // Log the deletion
        await _logItemDeletion(itemToDelete);

        final StorageService storageService = StorageService();
        String? userID = await storageService.getStoredUserId();

        if (userID != null) {
          await deleteItem(userID, itemId.toString());
          setState(() {
            fridgeItemsNotify.removeWhere((item) => item['itemId'] == itemId);
            widget.fridgeItems.removeWhere((item) => item['itemId'] == itemId);
          });
        }
      } else {
        print('Item not found for deletion');
      }
    } catch (e) {
      // Handle any exceptions that might occur during the deletion
      print('Error deleting item: $e');
    }
  }

  void _dismissItem(dynamic itemId) {
    setState(() {
      dismissednotices.add(itemId);
      fridgeItemsNotify.removeWhere((item) => item['itemId'] == itemId);
    });
    // Save dismissednotices to persistent storage if needed
  }

  void _dismissAllItems() {
    setState(() {
      for (var item in fridgeItemsNotify) {
        dismissednotices.add(item['itemId']);
      }
      fridgeItemsNotify.clear();
    });
    // Save dismissednotices to persistent storage if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification List' , style: GoogleFonts.calligraffitti(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: Theme.of(context).primaryColor,
         
      ),
      body: Stack(
        children: [
          Background(type: 'Background1'),
          fridgeItemsNotify.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "No New Notifications",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: fridgeItemsNotify.length + 1,
                  itemBuilder: (context, index) {
                    if (index == fridgeItemsNotify.length) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: ElevatedButton(
                          onPressed: _dismissAllItems,
                          child: Text('Dismiss All'),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context)
                                .colorScheme
                                .secondary, // Background color of the button
                            onPrimary: Colors.white,
                          ),
                          // Text color
                        ),
                      );
                    }

                    var item = fridgeItemsNotify[index];
                    return ListTile(
  leading: item['imageUrl'] != null && item['imageUrl'].isNotEmpty
      ? Image.network(
          item['imageUrl'],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            // In case of an error (like a 404), use the default image
            return Image.asset('images/default_image.png', width: 50, height: 50, fit: BoxFit.cover);
          },
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        )
      : Image.asset('images/default_image.png', width: 50, height: 50, fit: BoxFit.cover),
  title: Text(item['name']),
  subtitle: Text(_getExpirationStatus(item)),
                     
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete,
                                size: 24,
                                color: Theme.of(context).primaryColor),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Item'),
                                    content: Text(
                                        'Are you sure you want to delete this item?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _deleteItem(item['itemId']);
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
                          IconButton(
                            icon: Icon(Icons.notifications_off_outlined,
                                size: 24,
                                color: Theme.of(context).primaryColor),
                            onPressed: () => _dismissItem(item['itemId']),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
