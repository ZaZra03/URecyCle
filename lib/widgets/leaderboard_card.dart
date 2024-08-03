import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'leaderboard_position.dart';

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