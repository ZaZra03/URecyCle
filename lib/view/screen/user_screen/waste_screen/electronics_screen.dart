import 'package:flutter/material.dart';

class ElectronicsScreen extends StatelessWidget {
  const ElectronicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Electronics Recycling")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Ensures horizontal centering
          children: [
            Icon(Icons.devices, size: 100, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(
              "Keep E-Waste Out of Landfills!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Ensures the title is centered
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Electronic waste contains valuable materials and hazardous substances. Take your old electronics "
                    "to a recycling center for safe disposal.\n\n"
                    "Did You Know? Recycling 1 million cell phones recovers 35,000 pounds of copper! ♻️",
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