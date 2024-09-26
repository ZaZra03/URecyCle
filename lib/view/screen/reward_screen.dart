import 'package:flutter/material.dart';

import '../../constants.dart';

class RewardScreen extends StatelessWidget {
  RewardScreen({super.key});

  final List<Map<String, dynamic>> rewards = [
    {'name': 'Snack', 'points': 100, 'image': Icons.fastfood},
    {'name': 'CP Load 50', 'points': 200, 'image': Icons.phone_android},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rewards',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(
            color: Colors.white), // Set back button color to white
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _redeemReward(context, rewards[index]);
            },
            child: Card(
              elevation: 4,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(rewards[index]['image'], size: 50),
                  const SizedBox(height: 10),
                  Text(rewards[index]['name'],
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  Text('${rewards[index]['points']} Points',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _redeemReward(BuildContext context, Map<String, dynamic> reward) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Redeem Reward'),
          content: Text(
              'Are you sure you want to redeem ${reward['name']} for ${reward['points']} points?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully redeemed ${reward['name']}!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Redeem'),
            ),
          ],
        );
      },
    );
  }
}
