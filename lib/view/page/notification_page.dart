import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for notifications
    final List<String> notifications = [
      'URecyCle is now open',
      'URecyCle is now closed',
      'Congratulations you place first in the leaderboards',
      'URecyCle is now open',
      'URecyCle is now closed',
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text(notifications[index]),
            subtitle: Text('August 14, 2024'), // You can adjust this to display real time
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle tap event if needed
              print('Notification tapped: ${notifications[index]}');
            },
          );
        },
      ),
    );
  }
}
