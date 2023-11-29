//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridgemasters/inventory.dart';
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';
import 'package:fridgemasters/nutritionpage.dart';
import 'package:fridgemasters/widgets/textonlybutton.dart';
import 'package:fridgemasters/settings.dart';
import 'package:fridgemasters/notificationlist.dart';
import 'package:fridgemasters/foodentry.dart'; // Import the food entry page
import 'package:fridgemasters/Services/database_service.dart';
import 'package:fridgemasters/Services/storage_service.dart';
import 'package:fridgemasters/Services/deleteitem.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:uuid/uuid.dart';
import 'package:fridgemasters/language_change_notifier.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

String convertToDisplayFormat(String date) {
  var parts = date.split('-');
  if (parts.length == 3) {
    return '${parts[1]}/${parts[2]}/${parts[0]}'; // Convert to MM/DD/YYYY
  }
  return date; // Return the original string if the format isn't as expected
}

class ExpiringItemTile extends StatefulWidget {
  final String expirationDate;
  final String purchaseDate;
  final Widget child;

  ExpiringItemTile({
    required this.expirationDate,
    required this.purchaseDate,
    required this.child,
  });

  @override
  _ExpiringItemTileState createState() => _ExpiringItemTileState();
}

class _ExpiringItemTileState extends State<ExpiringItemTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _nonExpiringBorder(Widget child) {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: Color.fromARGB(255, 168, 169, 173), width: 0.8),
        borderRadius: BorderRadius.circular(70),
      ),
      child: child,
    );
  }

  Widget _closeToExpiringBorder(Widget child) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        final color = ColorTween(
          begin: Colors.amber,
          end: Color.fromARGB(255, 197, 188, 67),
        ).lerp(_animationController.value);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: color!, width: 3.0),
            borderRadius: BorderRadius.circular(70),
          ),
          child: child,
        );
      },
    );
  }

  Widget _expiredBorder(Widget child) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        final color = ColorTween(
          begin: Color.fromARGB(255, 177, 21, 21),
          end: Color.fromARGB(255, 131, 122, 121),
        ).lerp(_animationController.value);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: color!, width: 4.0
            ),
            borderRadius: BorderRadius.circular(70), // Rounded corners
          ),
          child: child,
        );
      },
    );
  }

  Widget _getExpirationBorder(
      String expirationDate, String purchaseDate, Widget child) {
    final expiryDate = DateTime.parse(expirationDate);
    final currentDate = DateTime.now();
    final currentDateAtMidnight =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    final purchaseDateParsed = DateTime.parse(purchaseDate);
    final daysLeft = expiryDate.difference(currentDateAtMidnight).inDays;

    if (expiryDate.isBefore(currentDateAtMidnight) ||
        expiryDate.isBefore(purchaseDateParsed)) {
      return _expiredBorder(child);
    } else if (daysLeft <= 7) {
      return _closeToExpiringBorder(child);
    } else {
      return _nonExpiringBorder(child);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getExpirationBorder(
        widget.expirationDate, widget.purchaseDate, widget.child);
  }
}

class YourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get today's date
    String currentDate =
        DateTime.now().toString().split(' ')[0]; // YYYY-MM-DD format

    return Column(
      children: [
        // Today's Date Centered
        Text(
          'Today\'s Date: $currentDate',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10), // Spacing

        // Legend
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> fridgeItems;

  const HomePage({Key? key, required this.fridgeItems}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> fridgeItems = [];
  final TextEditingController _searchController = TextEditingController();
  final DatabaseService dbService = DatabaseService();
  List<Map<String, dynamic>> filteredItems = [];
  @override
  void initState() {
    super.initState();
    _loadFridgeItems();
    _searchController.addListener(() {
      _updateSearchQuery(_searchController.text);
    });
  }

  void _loadFridgeItems() async {
    //Logan S
//Michael Ndudim
    try {
      final storageService = StorageService();

      // Fetch stored userId from storage
      String? userID = await storageService.getStoredUserId();

      if (userID != null) {
        List<Map<String, dynamic>> loadedItems =
            await dbService.getUserInventory(userID);

// Map the loadedItems to the expected format
        List<Map<String, dynamic>> formattedItems = loadedItems.map((item) {
          String imageUrl = item['imageUrl'] ??
              'images/default_image.png'; // Use the image URL from the database if available
          return {
            'itemId': item['itemId'], // Include the itemId
            'name': item['productName'],
            'quantity': '${item['quantity']}',
            'purchaseDate': item['dateOfPurchase']
                .split(" ")[0], // Only take the date part, exclude the time
            'expirationDate': item['expirationDate']
                .split(" ")[0], // Only take the date part, exclude the time

            'imageUrl': item['imageUrl'],
            'nutrients': {
              'ENERC_KCAL': item['ENERC_KCAL'],
              'PROCNT': item['PROCNT'],
              'FAT': item['FAT'],
              'CHOCDF': item['CHOCDF'],
              'FIBTG': item['FIBTG'],
            }, // Keep as default or adjust as necessary
          };
        }).toList();
        print(
            'Formatted Items: $formattedItems'); // Print the formattedItems list
        setState(() {
          widget.fridgeItems.addAll(formattedItems);
          filteredItems = [...widget.fridgeItems];
        });
      } else {
        print('No user ID found in storage.');
      }
    } catch (error) {
      print('Error fetching items: $error');
      // Handle any errors, maybe show a notification to the user
    }
  }

  void _updateSearchQuery(String query) {
    //Logan S
//Michael Ndudim
    if (query.isEmpty) {
      setState(() {
        filteredItems = [...widget.fridgeItems];
      });
      return;
    }

    List<Map<String, dynamic>> tempList = [];
    for (var item in widget.fridgeItems) {
      // Convert both strings to lowercase for a case-insensitive comparison
      String itemName = item['name'].toString().toLowerCase();
      String searchQuery = query.toLowerCase();

      // Check if the item name contains the search query
      if (itemName.contains(searchQuery)) {
        tempList.add(item);
      }
    }

    setState(() {
      filteredItems = tempList;
    });
  }

  void _navigateToAddItem() async {
    //Logan S
    //Michael Ndudim
    final FoodItem? newFoodItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodEntry(onFoodItemAdded: (foodItem) {
          Navigator.pop(context, foodItem);
          // Return the food item back to this page
        }),
      ),
    );

    if (newFoodItem != null) {
      setState(() {
        widget.fridgeItems.add({
          'ItemID': newFoodItem.itemId,
          'name': newFoodItem.name,
          'quantity': '${newFoodItem.quantity}',
          'purchaseDate': newFoodItem.dateOfPurchase.toString(),
          'expirationDate': newFoodItem.expirationDate.toString(),
          'imageUrl': ['imageUrl'],
        });
        filteredItems.add({
          'ItemID': newFoodItem.itemId,
          'name': newFoodItem.name,
          'quantity': '${newFoodItem.quantity}',
          'purchaseDate': newFoodItem.dateOfPurchase.toString(),
          'expirationDate': newFoodItem.expirationDate.toString(),
          'imageUrl': ['imageUrl'],
        });
      });
    }
  }

  Color _getExpirationColor(String expirationDate, String purchaseDate) {
    final expiryDate = DateTime.parse(expirationDate);
    final currentDate = DateTime.now();
    final currentDateAtMidnight =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    final purchaseDateParsed = DateTime.parse(purchaseDate);
    final daysLeft = expiryDate.difference(currentDateAtMidnight).inDays;

    // Condition 1: If the expiration date is before the current date.
    if (expiryDate.isBefore(currentDateAtMidnight)) {
      return Color.fromARGB(255, 177, 21, 21);
    }
    // Condition 2: If the expiration date is before the purchase date.
    else if (expiryDate.isBefore(purchaseDateParsed)) {
      return Color.fromARGB(255, 177, 21, 21);
    } else if (daysLeft <= 7) {
      return const Color.fromARGB(255, 226, 166, 76);
    } else {
      return Color.fromARGB(255, 20, 220, 27);
    }
  }

  Widget _nonExpiringBorder(Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 20, 220, 27), width: 2.0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }

  ///Mireya Changes///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var iconPadding = EdgeInsets.all(screenWidth * 0.02);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(142.0), // Adjust the height as needed
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          //title: const Text(''),// Make the AppBar background transparent
          elevation: 0, // Removes the default shadow
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
          ),

          title: Column(
            mainAxisSize: MainAxisSize.min, // Use min size for the column
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0), // Adjust the padding to move the title down
                child: Center(
                  child: Text(
                    'The Fridge Masters',
                    style: GoogleFonts.calligraffitti(
                      textStyle: TextStyle(
                        fontSize: 28.0,
                        fontWeight:
                            FontWeight.bold, // Apply DM Serif Display font
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          leading: Transform.translate(
            offset: Offset(11, 19),
            child: IconButton(
              //icon: IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NotificationList(fridgeItems: widget.fridgeItems),
                  ),
                );
              },
            ),
          ),
          actions: [
            Transform.translate(
                offset: Offset(-11, 19),
                child: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Settings(),
                      ),
                    );
                  },
                )),
          ],

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              //padding: const EdgeInsets.symmetric(horizontal: 25.0),
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: Colors
                            .white, // Changes the cursor and selection handle color
                      ),
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: Colors.white, // Changes the cursor color
                    selectionColor: Colors.white
                        .withOpacity(0.5), // Changes the selection color
                    selectionHandleColor:
                        Colors.white, // Changes the selection handle color
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Filter based on food items',
                    prefixIcon: Icon(Icons.search), // Icon for search
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Choose border color
                      borderRadius:
                          BorderRadius.circular(10), // Choose border radius
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .white), // Changes the border color when the TextField is focused
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          //const Background(type: 'Background1'),

          Background(type: 'Background1'),

          Center(
              child: widget.fridgeItems.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Add Items to your fridge!'),
                        Icon(Icons.arrow_downward, color: Colors.red),
                      ],
                    )
                  : ListView.builder(
                      itemCount: filteredItems.length +
                          1, // +1 for the header (date and legend)

                      itemBuilder: (context, index) {
                        // This is for the header, which contains the date and legend
                        Color _getTextColor(BuildContext context) {
                          // Determine if the theme is dark or light
                          bool isDarkMode =
                              Theme.of(context).brightness == Brightness.dark;

                          // Set text color based on the theme
                          return isDarkMode ? Colors.white : Colors.black;
                        }

                        if (index == 0) {
                          bool isDarkMode =
                              Theme.of(context).brightness == Brightness.dark;
                          Color textColor =
                              isDarkMode ? Colors.white : Colors.black;
                          return Column(
                            children: [
                              SizedBox(height: 10),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Today\'s Date: ',
                                        style: TextStyle(
                                            color: _getTextColor(context),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text:
                                            '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                                        style: TextStyle(
                                          color: _getTextColor(context),
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        } else {
                          // Index is greater than 0, so it's an item
                          final adjustedIndex = index - 1;
                          if (adjustedIndex < filteredItems.length) {
                            final item = filteredItems[adjustedIndex];
                            final itemId = item['itemId'];
                            print('Item ID at index $index: $itemId');

                            Color _getLightGrayColor() {
                              // Light gray color #F0F0F0
                              return Color.fromRGBO(240, 240, 240,
                                  1); // Opacity is set to 1 for a solid color
                            }

                            ImageProvider getImageProvider(String? imageUrl) {
                              // Check if imageUrl is a network URL
                              if (imageUrl != null &&
                                  Uri.tryParse(imageUrl)?.hasAbsolutePath ==
                                      true) {
                                // If it's a valid URL, return a NetworkImage
                                return NetworkImage(imageUrl);
                              } else {
                                // If it's not a valid URL (or is null), return a AssetImage
                                return AssetImage('images/default_image.png');
                              }
                            }

                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                    color: _getLightGrayColor(),

                                    //color: _getPastelColor(index),
                                    elevation: 4.0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Color.fromARGB(
                                            255, 120, 124, 141), // Same color
                                        width: 0.8, // Same width
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          70), // Same rounded corners as in _expiredBorder
                                    ),
                                    child: ExpiringItemTile(
                                      expirationDate: item['expirationDate'],
                                      purchaseDate: item['purchaseDate'],
                                      child: Container(
                                        height: 137,
                                        child: Stack(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .all(
                                                        16.0), // Image padding
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                NutritionPage(
                                                                    item:
                                                                        item), // itemData should include 'name' and 'nutrients'
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  197,
                                                                  193,
                                                                  191),
                                                              width: 3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        width: 100,
                                                        height: 100,
                                                        child: Image.network(
                                                          item['imageUrl']
                                                                  .toString() ??
                                                              '',
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                            // In case of an error (like a 404), use the default image
                                                            return Image.asset(
                                                                'images/default_image.png',
                                                                fit: BoxFit
                                                                    .cover);
                                                          },
                                                          loadingBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Widget child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                value: loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        loadingProgress
                                                                            .expectedTotalBytes!
                                                                    : null,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 6,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: RichText(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  text:
                                                                      TextSpan(
                                                                    style: DefaultTextStyle.of(
                                                                            context)
                                                                        .style,
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                              'Name: ',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: 12,
                                                                              color: Colors.black)), // Descriptor size
                                                                      TextSpan(
                                                                          text:
                                                                              '${item['name']}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Colors.black,
                                                                            /* color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),decoration: TextDecoration.underline*/
                                                                          )), // User-entered text size
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    style: DefaultTextStyle.of(
                                                                            context)
                                                                        .style,
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                              'Purchased: ',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black)),
                                                                      TextSpan(
                                                                          text: convertToDisplayFormat(item[
                                                                              'purchaseDate']),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.black,
                                                                            /*color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255)*/
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Center(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    style: DefaultTextStyle.of(
                                                                            context)
                                                                        .style,
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                              'Qty: ',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black)),
                                                                      TextSpan(
                                                                          text:
                                                                              '${item['quantity']}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                15.5,
                                                                            color:
                                                                                Colors.black,
                                                                            /*color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255)*/
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    style: DefaultTextStyle.of(
                                                                            context)
                                                                        .style,
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                              'Expiry: ',
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black)),
                                                                      TextSpan(
                                                                        text: convertToDisplayFormat(
                                                                            item['expirationDate']),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                17,
                                                                            color:
                                                                                _getExpirationColor(item['expirationDate'], item['purchaseDate'])),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                              top: 2,
                                              right: 2,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  size: 22,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to delete this item?'),
            // Removed the Row containing the Checkbox and Text
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Closes the dialog
            },
            child: Text('Cancel'),
          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              final currentItem =
                                                                  widget.fridgeItems[
                                                                      adjustedIndex];
                                                              await _logItemDeletion(
                                                                  currentItem);
                                                              try {
                                                                final StorageService
                                                                    storageService =
                                                                    StorageService();
                                                                String? userID =
                                                                    await storageService
                                                                        .getStoredUserId();

                                                                if (userID !=
                                                                    null) {
                                                                  String
                                                                      itemIdString =
                                                                      itemId
                                                                          .toString();
                                                                  await deleteItem(
                                                                      userID,
                                                                      itemIdString);

                                                                  // If the deletion was successful in the backend, remove from the local list
                                                                  setState(() {
                                                                    widget
                                                                        .fridgeItems
                                                                        .removeAt(
                                                                            adjustedIndex);
                                                                    filteredItems.removeWhere((item) =>
                                                                        item[
                                                                            'itemId'] ==
                                                                        currentItem[
                                                                            'itemId']);
                                                                  });
                                                                }
                                                              } catch (e) {
                                                                // Handle any exceptions that might occur during the deletion
                                                                print(
                                                                    'Error deleting item: $e');
                                                              }

                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Keep this line to close the dialog
                                                            },
                                                            child:
                                                                Text('Delete'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )));
                          } else {
                            return Container();
                          }
                        }
                      },
                    )),
        ],
      ),
      bottomNavigationBar: Taskbar(
        currentIndex: 0,
        backgroundColor: theme.bottomAppBarColor,
        //backgroundColor: Color.fromARGB(255, 233, 232, 232),
        onTabChanged: (index) {},
        onFoodItemAdded: (foodItem) {
          // You need to provide this callback
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItem,
        child: Icon(Icons.add),

        //backgroundColor: const Color.fromARGB(210, 84, 85, 87),

        //backgroundColor: const Color.fromARGB(210, 33, 149, 243),
        backgroundColor: theme.colorScheme.secondary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
