import 'package:flutter/material.dart';

class CardboardScreen extends StatelessWidget {
  const CardboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cardboard Recycling")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Ensures horizontal centering
          children: [
            Icon(Icons.archive, size: 100, color: Colors.brown),
            SizedBox(height: 20),
            Text(
              "Give Cardboard a Second Life!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Ensures text is centered
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Flatten those boxes, peel off any tape, and drop them in the recycle bin. "
                    "Recycling cardboard not only saves trees but also reduces landfill waste! 🌍\n\n"
                    "Fun Fact: Recycling 1 ton of cardboard saves over 9 cubic yards of landfill space. "
                    "Let’s make a difference!",
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