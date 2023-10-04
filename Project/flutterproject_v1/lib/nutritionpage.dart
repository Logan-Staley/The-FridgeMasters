import 'package:flutter/material.dart';
import 'widgets/paragraphtext.dart'; // Import the ParagraphTextBox component

class NutritionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ParagraphTextBox(
              text:
                  'Nutrition is the biochemical and physiological process by which an organism uses food to support its life.',
            ),
            SizedBox(height: 16),
            ParagraphTextBox(
              text:
                  'It includes ingestion, absorption, assimilation, biosynthesis, catabolism, and excretion.',
            ),
          ],
        ),
      ),
    );
  }
}
