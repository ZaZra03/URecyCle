import 'package:flutter/material.dart';
import 'custom_card.dart';

class LeaderboardCard extends StatelessWidget {
  const LeaderboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Donation leaderboard',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'July • Global',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LeaderboardPosition(
                position: 2,
                name: 'Abdow',
                amount: '₱22,430.32',
                color: Colors.orange,
                isFirst: false,
              ),
              LeaderboardPosition(
                position: 1,
                name: 'Sneaky',
                amount: '₱35,038.82',
                color: Colors.red,
                isFirst: true,
              ),
              LeaderboardPosition(
                position: 3,
                name: '재영',
                amount: '₱22,187.88',
                color: Colors.green,
                isFirst: false,
              ),
            ],
          ),
          const UserCard(),
        ],
      ),
    );
  }
}

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

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    double avatarRadius = MediaQuery.of(context).size.width * 0.08;

    return Card(
      margin: const EdgeInsets.only(top: 20),
      color: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: avatarRadius,
          child: Text(
            "EM",
            style: TextStyle(
                color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.03), // Smaller font size
          ),
        ),
        title: Text(
          'Ezra Micah (me)',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.04, // Smaller font size
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Philippines',
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.03, // Smaller font size
              ),
            ),
            Text(
              '1 goal supported this month',
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.03, // Smaller font size
              ),
            ),
          ],
        ),
        trailing: Text(
          '₱16.53',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.04, // Smaller font size
          ),
        ),
      ),
    );
  }
}