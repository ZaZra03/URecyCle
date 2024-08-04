import 'package:flutter/material.dart';

import '../../utils/navigation_utils.dart';
import '../leaderboard_screen.dart';
import '../widget/custom_card.dart';
import '../widget/leaderboard_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              LeaderboardCard(
                onTap: () {
                  handleTap(context, const LeaderboardPage());
                },
              ),
              const CustomCard(
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
