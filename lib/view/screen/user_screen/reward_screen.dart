import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../constants.dart';
import '../../../provider/user_provider.dart';

class RewardScreen extends StatelessWidget {
  RewardScreen({super.key});

  final List<Map<String, dynamic>> rewards = [
    {'name': 'Snack', 'points': 1, 'image': Icons.fastfood, 'available': true},
    {'name': 'CP Load 50', 'points': 200, 'image': Icons.phone_android, 'available': false},
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final lbUser = userProvider.lbUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rewards',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  ((lbUser?.points ?? 0) * 0.10).toStringAsFixed(2),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _showPointsDialog(context);
                  },
                  child: const Icon(Icons.info_outline, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
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
                  Text('${rewards[index]['points']} Stars',
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 5),
                  Text(
                    rewards[index]['available'] ? 'Available' : 'Not Available',
                    style: TextStyle(
                      color: rewards[index]['available'] ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _redeemReward(BuildContext context, Map<String, dynamic> reward) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final lbUser = userProvider.lbUser;

    // Check if the reward is available
    if (!reward['available']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This reward is not available!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Check if user has enough points
    if ((lbUser?.points ?? 0) < reward['points']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient points to redeem this reward!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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
                _showQrCode(context, reward);
              },
              child: const Text('Redeem'),
            ),
          ],
        );
      },
    );
  }

  void _showQrCode(BuildContext context, Map<String, dynamic> reward) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final lbUser = userProvider.lbUser;

    String qrData = '{"studentNumber": "${lbUser?.studentNumber}","name": "${reward['name']}", "points": ${reward['points']}}';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('QR Code for ${reward['name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Show this QR code to the admin to claim your reward!',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                userProvider.notifyListeners();
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPointsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Points Conversion'),
          content: const Text('Stars = Points * 0.10', style: TextStyle(fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
