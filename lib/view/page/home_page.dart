import 'package:flutter/material.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/leaderboard_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Column(
            children: [
              LeaderboardCard(),
              CustomCard(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    // Add other widgets here if needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
