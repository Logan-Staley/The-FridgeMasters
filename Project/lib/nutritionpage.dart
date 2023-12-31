import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:flutter/material.dart';
import 'package:fridgemasters/widgets/taskbar.dart';
import 'package:fridgemasters/widgets/backgrounds.dart';

class NutritionPage extends StatelessWidget {
  final Map<String, dynamic> item; // Now it expects the entire item

  const NutritionPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nutrients = item['nutrients']; // Extracting nutrients from the item
    final name = item['name'] ?? 'Unknown Item'; // Extracting name from the item
    final highestNutrient = _findHighestNutrient(nutrients);
    return Scaffold(
      //backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        

        title: Text('Nutrition Facts for $name'),

       // title: const Text('Nutrition Page'),
         backgroundColor: Theme.of(context).primaryColor,

      ),
      body: Stack(
        children: [
          Background(type:'Background1'),
        SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           // Background(type: 'Background1'),
            Center(
  child: Text(
    'Discover the Nutritional Power of $name!',
    style: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    ),
    textAlign: TextAlign.center, // Ensure text alignment is centered
  ),
),

SizedBox(height: 16),

// Adding the image and recommended serving size text
if (item['imageUrl'] != null)
  Center(
    child: Image.network(
      item['imageUrl'],
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        // Return an empty container in case of an error
        return Container();
      },
    ),
  ),
SizedBox(height: 8),
// Aligning the text to the left side
Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Text(
    'For Recommended Serving Size:',
    style: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
  ),
),
//SizedBox(height: 2),

// Card widget for nutritional facts
            SizedBox(height: 2),
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    nutritionalFact('Calories', nutrients['ENERC_KCAL'], 'kcal'),
                    nutritionalFact('Protein', nutrients['PROCNT'], 'grams', additionalInfo: 'Protein is essential for muscle growth and repair. 💪'),
                    nutritionalFact('Fat', nutrients['FAT'], 'grams'),
                    nutritionalFact('Carbs', nutrients['CHOCDF'], 'grams', additionalInfo: 'Carbs are a great source of energy. 🏃‍♂️'),
                    nutritionalFact('Fiber', nutrients['FIBTG'], 'grams', additionalInfo: 'Fiber helps with digestion. 🍏'),
                    // ... Add more nutritional facts as needed
                    
                  ],
                  
                ),
              ),
            ),
             SizedBox(height: 16),
            Center(
  child: _buildQuickFactsSection(highestNutrient, nutrients),
),
 SizedBox(height: 16), // Add some space between the cards and the image
          Center(
            //child: Image.asset('images/foodchart.jpg'), // This will display your image
          ),
          ],
        ),
      ),
        ],
      ),
      
    );
  }

  Widget nutritionalFact(String name, dynamic value, String unit, {String? additionalInfo}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$name:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${value ?? 'N/A'} $unit',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}

// Method to find the highest nutrient
String _findHighestNutrient(Map<String, dynamic> nutrients) {
  String highestNutrient = '';
  num highestValue = 0; // Use 'num' to handle both 'int' and 'double'

  nutrients.forEach((key, value) {
    // Skip 'Calories' when finding the highest nutrient
    if (key == 'ENERC_KCAL') return;

    if (value is String) {
      value = num.tryParse(value); // Try parsing if value is a string
    }
    if (value is num && value > highestValue) {
      highestValue = value;
      highestNutrient = key;
    }
  });

  return highestNutrient;
}

  // Method to build the quick facts section
  Widget _buildQuickFactsSection(String highestNutrient, Map<String, dynamic> nutrients) {
  return Card(
    color: Color.fromARGB(118, 185, 171, 171),
    elevation: 4.0,
    child: Padding(
      
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Facts:',
            style: TextStyle(
              fontSize: 20.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '   • Protein is essential for muscle growth and repair. 💪',
            style: TextStyle(
              fontSize: 16.0, // Adjust the font size as needed
            ),
          ),
          Text(
            '   • Carbs are a great source of energy. 🍞🏃‍♂️',
            style: TextStyle(
              fontSize: 16.0, // Adjust the font size as needed
            ),
          ),
          Text(
            '   • Fat is crucial for normal body function and energy. 🧀🏃‍♂️',
            style: TextStyle(
              fontSize: 16.0, // Adjust the font size as needed
            ),
          ),
          Text(
            '   • Fiber aids in digestion and gut health. 🍏',
            style: TextStyle(
              fontSize: 16.0, // Adjust the font size as needed
            ),
          ),
          if (highestNutrient.isNotEmpty) 
            Text(
              '\nThis item is high in ${_getNutrientName(highestNutrient)} (${nutrients[highestNutrient]}g), which makes it great for ${_getNutrientBenefit(highestNutrient)}.\n\n*Disclamer: These numbers are general estimates and may not accurately portray your food item nutrition.\n\nFor most accurate info, please see the Nurtitional Information label on specific food item.',
              style: TextStyle(
                fontSize: 15.0, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      
    ),
    
  );
  
}

  // Helper method to get nutrient name
  String _getNutrientName(String nutrientKey) {
    switch (nutrientKey) {
      case 'ENERC_KCAL':
        return 'Calories';
      case 'PROCNT':
        return 'Protein';
      case 'FAT':
        return 'Fat';
      case 'CHOCDF':
        return 'Carbs';
      case 'FIBTG':
        return 'Fiber';
      default:
        return 'Unknown Nutrient';
    }
  }

  // Helper method to get nutrient benefit
  String _getNutrientBenefit(String nutrientKey) {
    switch (nutrientKey) {
      case 'PROCNT':
        return 'muscle growth and repair';
      case 'CHOCDF':
        return 'providing energy';
      case 'FAT':
        return 'normal body function';
      case 'FIBTG':
        return 'digestion and gut health';
      default:
        return 'overall health';
        
    }
  
  }