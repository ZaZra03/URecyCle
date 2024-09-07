import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../utils/navigation_utils.dart';
import '../leaderboard_screen.dart';
import '../widget/leaderboard_card.dart';
import 'package:urecycle_app/model/leaderboard_model.dart' as leaderboard_model;


class Home extends StatelessWidget {
  final leaderboard_model.LeaderboardEntry? lbUser;
  final UserModel? user;
  List<Map<String, dynamic>> top3Users = [];

  Home({super.key, this.lbUser, this.user, required this.top3Users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LeaderboardCard(
              lbUser: lbUser,
              user: user,
              top3Users: top3Users,
              onTap: () => handleTap(context, const LeaderboardPage()),
            ),
            _buildInfoCard(
              title: 'Total Disposed Recycled Waste',
              value: '0',
              buttonText: 'Recycle',
              onButtonPressed: () {
                // Add your action here
              },
            ),
            _buildImageCard(
              imagePath: 'assets/images/SGD_12.png',
              title: 'Sustainable Development Goal 12',
              subtitle: 'Learn more about how SDG 12 fosters sustainable practices.',
              onButtonPressed: () {
                // Add your action here
              },
            ),
            _buildImageCard(
              imagePath: 'assets/images/MNV.jpg',
              title: 'Mission and Vision',
              subtitle: 'Discover the University Mission and Vision.',
              onButtonPressed: () {
                // Add your action here
              },
            ),
            const SizedBox(height: 110), // Adjust spacing if needed
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey,
                ),
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required VoidCallback onButtonPressed,
  }) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: onButtonPressed,
                child: const Text('Read'),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}