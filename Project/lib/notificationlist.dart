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

    // Sort items by expiration date
    fridgeItemsNotify.sort((a, b) => _compareExpirationDates(a, b));
  }

  // Compare function for sorting
  int _compareExpirationDates(Map<String, dynamic> a, Map<String, dynamic> b) {
    DateTime expirationDateA = DateTime.parse(a['expirationDate']);
    DateTime expirationDateB = DateTime.parse(b['expirationDate']);

    // Earlier dates will appear first
    return expirationDateA.compareTo(expirationDateB);
  }

 String _getExpirationStatus(Map<String, dynamic> item) {
  DateTime expirationDate = DateTime.parse(item['expirationDate']);
  DateTime currentDate = DateTime.now();
  DateTime currentDateAtMidnight = DateTime(currentDate.year, currentDate.month, currentDate.day);

  // Calculate the number of days left until expiration
  int daysUntilExpiration = expirationDate.difference(currentDateAtMidnight).inDays;

  if (daysUntilExpiration < 0) {
    // Item is expired
    return "${item['name']} is expired. Expired on: ${DateFormat('MM/dd/yyyy').format(expirationDate)}";
  } else if (daysUntilExpiration <= 7) {
    // Item is about to expire (within 7 days, including today)
    return "${item['name']} is about to expire. Expires in $daysUntilExpiration day(s) on: ${DateFormat('MM/dd/yyyy').format(expirationDate)}";
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
  // Separate items into 'expired' and 'about to expire' lists
  List<Map<String, dynamic>> expiredItems = [];
  List<Map<String, dynamic>> aboutToExpireItems = [];

  for (var item in fridgeItemsNotify) {
    DateTime expirationDate = DateTime.parse(item['expirationDate']).toLocal();
    DateTime currentDate = DateTime.now();
    DateTime currentDateAtMidnight = DateTime(currentDate.year, currentDate.month, currentDate.day);

    if (expirationDate.isBefore(currentDateAtMidnight)) {
      expiredItems.add(item);
    } else if (expirationDate.difference(currentDateAtMidnight).inDays <= 7) {
      aboutToExpireItems.add(item);
    }
  }
Widget buildDividerTile(String title) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    color: Colors.grey[300], // Choose a color that makes the divider stand out
    child: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black,
      ),
    ),
  );
}
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification List', style: GoogleFonts.calligraffitti(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : ListView(
          children: [
            if (expiredItems.isNotEmpty) ...[
              buildDividerTile("Expired Items:"),
              ...expiredItems.map((item) => buildItemTile(item, context)).toList(),
            ],
            if (aboutToExpireItems.isNotEmpty) ...[
              buildDividerTile("Items about to expire:"),
              ...aboutToExpireItems.map((item) => buildItemTile(item, context)).toList(),
            ],
                  ],
                ),
        ],
      ),
    );
  }

  Widget buildItemTile(Map<String, dynamic> item, BuildContext context) {
  return ListTile(
    leading: item['imageUrl'] != null && item['imageUrl'].isNotEmpty
        ? Image.network(
            item['imageUrl'],
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
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
          icon: Icon(Icons.delete, size: 24, color: Theme.of(context).primaryColor),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete Item'),
                  content: Text('Are you sure you want to delete this item?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
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
          icon: Icon(Icons.notifications_off_outlined, size: 24, color: Theme.of(context).primaryColor),
          onPressed: () => _dismissItem(item['itemId']),
        ),
      ],
    ),
  );
}
}