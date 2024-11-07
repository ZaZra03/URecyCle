import 'package:flutter/material.dart';

class PaperScreen extends StatelessWidget {
  const PaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paper Recycling")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Ensures horizontal centering
          children: [
            Icon(Icons.sticky_note_2, size: 100, color: Colors.lightGreen),
            SizedBox(height: 20),
            Text(
              "Give Paper Another Purpose!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Ensures title text is centered
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Don’t let paper go to waste! Remove any plastic coverings and keep paper products clean "
                    "before recycling.\n\n"
                    "Every ton of paper recycled saves around 17 trees. 🌳 Let’s protect our forests and "
                    "create a greener future!",
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
