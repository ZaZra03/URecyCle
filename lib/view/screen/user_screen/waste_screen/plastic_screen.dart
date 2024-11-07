import 'package:flutter/material.dart';

class PlasticScreen extends StatelessWidget {
  const PlasticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plastic Recycling")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Ensures horizontal centering
          children: [
            Icon(Icons.recycling, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Turn Plastic Problems into Solutions!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Ensures text is centered
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Recycle only plastics marked with the recycling symbol. Separate different types of plastics "
                    "for the best results.\n\n"
                    "Remember: Recycling 1 ton of plastic saves up to 2,000 pounds of oil! 🌎 Let’s reduce our "
                    "carbon footprint together.",
                textAlign: TextAlign.center, // Ensures the paragraph text is centered
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
