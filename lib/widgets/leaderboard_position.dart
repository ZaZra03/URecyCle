import 'package:flutter/material.dart';

class LeaderboardPosition extends StatelessWidget {
  final int position;
  final String name;
  final String amount;
  final Color color;
  final bool isFirst;

  const LeaderboardPosition({super.key,
    required this.position,
    required this.name,
    required this.amount,
    required this.color,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    double avatarRadius = isFirst ? MediaQuery.of(context).size.width * 0.12 : MediaQuery.of(context).size.width * 0.10;
    double fontSize = isFirst
        ? MediaQuery.of(context).size.width * 0.08
        : MediaQuery.of(context).size.width * 0.06; // Adjust font size based on position

    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: color,
              child: Text(
                '$position',
                style: TextStyle(fontSize: fontSize, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}