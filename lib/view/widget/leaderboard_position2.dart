import 'package:flutter/material.dart';

class LeaderboardPosition extends StatelessWidget {
  final int position;
  final String name;
  final String points;
  final Color color;
  final bool isFirst;

  const LeaderboardPosition({
    super.key,
    required this.position,
    required this.name,
    required this.points,
    required this.color,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxAvatarRadius = 60.0; // Maximum radius for the avatar
    double maxFontSize = 20.0; // Maximum font size for the position number

    double avatarRadius = isFirst
        ? ((screenWidth * 0.10 + screenHeight * 0.05) / 2)
        .clamp(0.0, maxAvatarRadius) // Combined scaling with max constraint
        : ((screenWidth * 0.08 + screenHeight * 0.04) / 2)
        .clamp(0.0, maxAvatarRadius);
    double fontSize = isFirst
        ? ((screenWidth * 0.07 + screenHeight * 0.03) / 2)
        .clamp(0.0, maxFontSize) // Combined scaling with max constraint
        : ((screenWidth * 0.05 + screenHeight * 0.02) / 2)
        .clamp(0.0, maxFontSize);

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
            fontSize: ((screenWidth * 0.04 + screenHeight * 0.02) / 2)
                .clamp(0.0, maxFontSize),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          points,
          style: TextStyle(
            fontSize: ((screenWidth * 0.04 + screenHeight * 0.02) / 2)
                .clamp(0.0, maxFontSize),
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
