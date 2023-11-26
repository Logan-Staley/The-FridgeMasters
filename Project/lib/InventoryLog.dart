import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Import to access the global logFile variable

class InventoryLog extends StatefulWidget {
  @override
  _InventoryLogState createState() => _InventoryLogState();
}

class _InventoryLogState extends State<InventoryLog> {
  List<String> logEntries = [];

  @override
  void initState() {
    super.initState();
    _loadLog();
  }

  Future<void> _loadLog() async {
    try {
      String fileContents = await logFile.readAsString();
      logEntries = fileContents.split('\n');
      setState(() {});
    } catch (e) {
      print('Error reading log file: $e');
      setState(() {
        logEntries = ['Error loading log contents.'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Historical Inventory Log',
          style: GoogleFonts.calligraffitti(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: logEntries.isEmpty
          ? Center(child: Text('No log data available.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: logEntries.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      logEntries[index],
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
