import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Import to access the global logFile variable

class InventoryLog extends StatefulWidget {
  @override
  _InventoryLogState createState() => _InventoryLogState();
}

class _InventoryLogState extends State<InventoryLog> {
  String logContents = '';

  @override
  void initState() {
    super.initState();
    _loadLog();
  }

  Future<void> _loadLog() async {
    try {
      // Read the log file content
      logContents = await logFile.readAsString();
      setState(() {}); // Update the UI with the log contents
    } catch (e) {
      print('Error reading log file: $e');
      setState(() {
        logContents = 'Error loading log contents.';
      });
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
        padding: const EdgeInsets.all(8.0),
        child:
            Text(logContents.isEmpty ? 'No log data available.' : logContents),
      ),
    );
  }
}
