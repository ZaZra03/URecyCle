import 'package:flutter/material.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unknown Object")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Ensures horizontal centering
          children: [
            Icon(Icons.help_outline, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "We Couldn't Identify This Object",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Ensures title is centered
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "The system couldn't determine the object in the image. "
                    "Please try another image or check if the object is clearly visible.\n\n"
                    "Need help? Try taking the picture in good lighting and with a clear background.",
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