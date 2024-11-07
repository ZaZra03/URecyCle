import 'package:flutter/material.dart';

class TrashScreen extends StatelessWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trash Disposal")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Ensures horizontal centering
          children: [
            Icon(Icons.delete, size: 100, color: Colors.red),
            SizedBox(height: 20),
            Text(
              "Think Before You Toss!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Ensures title is centered
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Not everything belongs in the trash. Make sure to recycle what you can, and toss only what "
                    "can’t be reused or recycled.\n\n"
                    "Fact: Reducing waste helps protect our planet. Every small action counts! 🌱",
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
