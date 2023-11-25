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
    // Format the nutrient values
    Map<String, String> formattedNutrients = formatSelectedNutritionalValues(totalNutrients);
    
    // Find the highest nutrient for the quick facts section
    String highestNutrientLabel = _findHighestNutrient(totalNutrients);

    return AlertDialog(
      title: const Text('Nutritional Information'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              'For 100g Serving Size: \n',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...formattedNutrients.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('${entry.key}: ${entry.value}'),
              );
            }).toList(),
            if (highestNutrientLabel.isNotEmpty)
              Text(
                '\nThis meal is high in $highestNutrientLabel (${formattedNutrients[highestNutrientLabel]}), which is great for ${_getNutrientBenefit(highestNutrientLabel)}.\n\n*Disclamer: These numbers are general estimates and may not accurately portray your food item nutrition.\nFor most accurate info, please see the Nurtitional Information label on specific food item.',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
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
  }
}
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
              child: Image.network(recipe.imageUrl),
            ),
            const SizedBox(height: 8),
            Text(
              'Ingredients:',
              style: Theme.of(context).textTheme.headline6,
            ),
            for (var line in recipe.ingredientLines)
              Text(line),
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