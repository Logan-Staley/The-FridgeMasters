import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fridgemasters/inventory.dart'; // Using the FoodItem class
import 'package:fridgemasters/Services/database_service.dart';
import 'package:fridgemasters/Services/storage_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class InventoryList extends StatefulWidget {
  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  final DatabaseService dbService = DatabaseService();
  final StorageService storageService = StorageService();
  final InventoryLogger logger = InventoryLogger();
  String logContents = '';
  List<String> uniqueLogEntries = [];

  final Set<String> loggedItemIds = Set<String>(); // Set to track logged items

  @override
  void initState() {
    super.initState();
    _loadInventoryAndLog();
  }

  Future<void> _loadInventoryAndLog() async {
    try {
      String? userID = await storageService.getStoredUserId();
      if (userID != null) {
        var loadedItems = await dbService.getUserInventory(userID);
        for (var itemJson in loadedItems) {
          var foodItem = FoodItem.fromJson(itemJson);
          await logger
              .writeLog(foodItem); // Pass FoodItem object to log by name
        }
        _loadLog(); // Load the log after updating it
      }
    } catch (e) {
      // Handle errors or show an error message
    }
  }

  Future<void> _loadLog() async {
    try {
      String logData = await logger.readLog();
      Set<String> entriesSet = Set<String>();

      uniqueLogEntries = logData.split('\n').where((line) {
        var parts = line.split(', Timestamp: ');
        if (parts.length < 2) return false;

        var content = parts[0];
        var timestamp = parts[1];

        var key = '$content-$timestamp';
        if (!entriesSet.contains(key)) {
          entriesSet.add(key);
          return true;
        }
        return false;
      }).toList();

      setState(() {});
    } catch (e) {
      // Handle read error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historical Inventory Log',
          style: GoogleFonts.calligraffitti(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'Here is a log of items that has been stored in the fridge regardless whether its expired, deleted, and existing items.\nLog Contents:\n${uniqueLogEntries.join('\n')}'),
        ),
      ),
    );
  }
}

class InventoryLogger {
  // Get the local path for storing the log file
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get the log file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/inventory_log.txt');
  }

  // Write a log entry to the file
  Future<void> writeLog(FoodItem item) async {
    final file = await _localFile;

    // Check if the file exists and create if not
    if (!await file.exists()) {
      await file.create(recursive: true);
    }

    String logData = await file.readAsString();
    String newLogEntry =
        '${item.name}: Quantity: ${item.quantity}, Timestamp: ${DateTime.now()}';

    // Check if the log already contains an entry with the same item name
    if (!logData.contains(item.name)) {
      await file.writeAsString('$newLogEntry\n', mode: FileMode.append);
    }
  }

  // Read the entire log file
  Future<String> readLog() async {
    try {
      final file = await _localFile;

      // Check if the file exists, and if not, create it
      if (!await file.exists()) {
        await file.create(
            recursive: true); // Creates the file and any necessary directories
        return 'Log file created. No existing log data.';
      }

      return await file.readAsString();
    } catch (e) {
      return 'Error reading or creating log: $e';
    }
  }
}
