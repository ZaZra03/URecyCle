import 'package:flutter/material.dart';

class GlassScreen extends StatelessWidget {
  const GlassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Glass Recycling")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Ensures horizontal centering
          children: [
            Icon(Icons.wine_bar, size: 100, color: Colors.lightBlue),
            SizedBox(height: 20),
            Text(
              "Turn Glass Into Gold for the Planet!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Ensures the title is centered
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Did you know glass can be recycled forever? Clean out jars, bottles, and glassware "
                    "before recycling them, and you’re helping make new products without waste.\n\n"
                    "Recycling just one glass bottle saves enough energy to light a 100-watt bulb for 4 hours! 💡",
                textAlign: TextAlign.center, // Ensures the body text is centered
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}