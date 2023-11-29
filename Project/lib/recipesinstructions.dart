import 'package:flutter/material.dart';
import 'foodentry.dart';
import 'package:url_launcher/url_launcher.dart';

class NutritionalInfoDialog extends StatelessWidget {
  final Map<String, dynamic> totalNutrients;

  const NutritionalInfoDialog({super.key, required this.totalNutrients});

  // Helper function to format the numbers
  Map<String, String> formatSelectedNutritionalValues(Map<String, dynamic> nutrients) {
    const selectedKeys = {'ENERC_KCAL', 'PROCNT', 'FAT', 'CHOCDF', 'FIBTG'};
    Map<String, String> formattedNutrients = {};

    for (var key in selectedKeys) {
      if (nutrients.containsKey(key) && nutrients[key] is Map) {
        final nutrient = nutrients[key];
        if (nutrient['quantity'] is num) {
          final quantity = nutrient['quantity'] as num;
          formattedNutrients[nutrient['label']] = '${quantity.toStringAsFixed(2)} ${nutrient['unit']}';
          
        }
      }
    }

    return formattedNutrients;
  }

  String _getNutrientBenefit(String label) {
    switch (label) {
      case 'Protein':
        return 'muscle growth and repair';
      case 'Carbohydrates (net)':
        return 'providing energy';
      case 'Fat':
        return 'normal body function';
      case 'Fiber':
        return 'digestion and gut health';
      default:
        return 'overall health';
    }
  }

 String _findHighestNutrient(Map<String, dynamic> nutrients) {
  // Define the keys we are interested in
  const selectedKeys = {'PROCNT', 'FAT', 'CHOCDF', 'FIBTG'};
  String highestLabel = '';
  double highestValue = 0;

  for (var key in selectedKeys) {
    if (nutrients.containsKey(key) && nutrients[key] is Map) {
      final nutrient = nutrients[key];
      final quantity = nutrient['quantity'] as double;
      // Use the label from the nutrient data, not the key from selectedKeys
      final label = nutrient['label'];
      
      if (quantity > highestValue) {
        highestValue = quantity;
        highestLabel = label;
      }
    }
  }

  return highestLabel;
}

  @override
Widget build(BuildContext context) {
  // Format the nutrient values, assuming 'Energy' is a key in your map
  Map<String, String> formattedNutrients = formatSelectedNutritionalValues(totalNutrients);
  String caloriesValue = '';
  if (formattedNutrients.containsKey('Energy')) {
    caloriesValue = formattedNutrients.remove('Energy')!;
  }
  
  // Find the highest nutrient for the quick facts section
  String highestNutrientLabel = _findHighestNutrient(totalNutrients);

  // TextStyle for nutrient labels (e.g., "Calories", "Protein", etc.)
  TextStyle nutrientLabelStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.blue[800], // Adjust the color to match your design
  );

  // TextStyle for nutrient values (e.g., "81.00 kcal", "5.42 grams", etc.)
  TextStyle nutrientValueStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.black,
  );

  return AlertDialog(
    title: const Text('Nutritional Information'),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          Text(
            'For Recommended Serving Size:',
            style: TextStyle(
              fontSize: 20.0, // Larger font size for the heading
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // Display "Calories" first
          if (caloriesValue.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Calories: ',
                      style: nutrientLabelStyle,
                    ),
                    TextSpan(
                      text: caloriesValue,
                      style: nutrientValueStyle,
                    ),
                  ],
                ),
              ),
            ),
          // Display the rest of the nutrients
          ...formattedNutrients.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${entry.key}: ',
                      style: nutrientLabelStyle,
                    ),
                    TextSpan(
                      text: '${entry.value}',
                      style: nutrientValueStyle,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          if (highestNutrientLabel.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                'This meal is high in $highestNutrientLabel (${formattedNutrients[highestNutrientLabel]}), which is great for ${_getNutrientBenefit(highestNutrientLabel)}.\n\n*Disclaimer: These numbers are general estimates and may not accurately portray your food item nutrition.\n\nFor most accurate info, please see the Nutritional Information label on specific food item.',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold, // Removed italics
                ),
              ),
            ),
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: const Text('Close'),
        onPressed: () {
            Navigator.of(context).pop();
        },
      ),
    ],
  );
}}
class RecipeInstructions extends StatelessWidget {
  final Recipe recipe; // Add this line to accept a Recipe object

  const RecipeInstructions({super.key, required this.recipe});

  // Function to launch URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to show Nutritional Information
  void _showNutritionalInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NutritionalInfoDialog(totalNutrients: recipe.totalNutrients);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.label),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _showNutritionalInfo(context),
              child: Card(
                child: Image.network(recipe.imageUrl),
                elevation: 4.0,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingredients:',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    for (var line in recipe.ingredientLines)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(line),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _launchURL(recipe.url),
              child: const Text('Full Instructions'),
            ),
            // Add more widgets to display all the recipe details
          ],
        ),
      ),
    );
  }
}