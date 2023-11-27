import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'main.dart'; // Import to access the global logFile variable

class ExpiryLog extends StatefulWidget {
  @override
  _ExpiryLogState createState() => _ExpiryLogState();
}

class _ExpiryLogState extends State<ExpiryLog> {
  List<String> logEntries = [];
  final DateFormat dateFormat =
      DateFormat('yyyy-MM-dd'); // Define the date format
  final RegExp dateRegex = RegExp(
      r'Expiration Date: (\d{4}-\d{2}-\d{2})'); // Regular expression to extract the date

  @override
  void initState() {
    super.initState();
    _loadLog();
  }

  Future<void> _loadLog() async {
    try {
      String fileContents = await logFile.readAsString();
      List<String> allEntries = fileContents.split('\n');
      DateTime now = DateTime.now();

      setState(() {
        // Filter entries to only include expired ones
        logEntries = allEntries.where((entry) {
          var matches = dateRegex.firstMatch(entry);
          if (matches != null && matches.groupCount >= 1) {
            DateTime entryDate = dateFormat.parse(matches.group(1)!);
            return entryDate
                .isBefore(now); // Check if the date is before current date
          }
          return false;
        }).toList();
      });
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
          'Historical Expiry Log',
          style: GoogleFonts.calligraffitti(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: logEntries.isEmpty
          ? Center(child: Text('No expired log data available.'))
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
