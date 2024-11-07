import 'package:flutter/material.dart';

class MetalScreen extends StatelessWidget {
  const MetalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Metal Recycling")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Ensures horizontal centering
          children: [
            Icon(Icons.coffee, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "Keep Metals in Motion!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Ensures title is centered
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Aluminum cans, steel containers, and other metals can be recycled infinitely! "
                    "Clean them up and toss them in the recycling bin.\n\n"
                    "Did you know? Recycling metal saves 95% of the energy needed to make it from scratch. "
                    "That’s a lot of electricity saved—just by recycling! ⚡",
                textAlign: TextAlign.center, // Ensures body text is centered
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
