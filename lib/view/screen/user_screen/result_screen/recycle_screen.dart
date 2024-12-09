import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../learnmore_screen/cardboard_screen.dart';
import '../learnmore_screen/glass_screen.dart';
import '../learnmore_screen/metal_screen.dart';
import '../learnmore_screen/paper_screen.dart';
import '../learnmore_screen/plastic_screen.dart';
import '../user_screen.dart';

class Recycle extends StatelessWidget {
  final String result;
  final String category;
  final String confidencePercentage;
  final int points;

  const Recycle({
    super.key,
    required this.result,
    required this.category,
    required this.confidencePercentage,
    required this.points,
  });

  void navigateToScreen(BuildContext context, String category) {
    final screenMapping = {
      'Cardboard': const CardboardScreen(),
      'Glass': const GlassScreen(),
      'Metal': const MetalScreen(),
      'Paper': const PaperScreen(),
      'Plastic': const PlasticScreen(),
    };

    final screen = screenMapping[category];
    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      print("No screen available for category: $category");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Constants.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.workspace_premium_outlined,
                size: 150,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Thanks for being eco-friendly!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Scanned Waste: $result (Recyclable)',
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Confidence: $confidencePercentage%',
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'You have received $points points!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserScreen(role: 'user')),
                          (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    width: screenWidth * 0.8,
                    alignment: Alignment.center,
                    child: const Text(
                      "Go Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add space between buttons
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    navigateToScreen(context, category);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    width: screenWidth * 0.8,
                    alignment: Alignment.center,
                    child: const Text(
                      "Learn More",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}