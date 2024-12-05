import 'package:flutter/material.dart';

import '../../../constants.dart';

class RecyclingItemsScreen extends StatelessWidget {
  static const Map<String, int> recyclingItems = {
    'Aluminum Cans': 15,
    'Cardboard Boxes': 10,
    'Disposable Plastic Cutlery': 3,
    'Glass Containers': 20,
    'Organic Waste': 0,
    'Paper': 8,
    'Paper Cups': 5,
    'Plastic Bags': 2,
    'Plastic Bottles': 10,
    'Plastic Cups': 5,
    'Plastic Food Containers': 8,
    'Plastic Straws': 1,
    'Styrofoam': 0,
  };

  const RecyclingItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recycling Points',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: recyclingItems.length,
          separatorBuilder: (context, index) => const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          itemBuilder: (context, index) {
            String item = recyclingItems.keys.elementAt(index);
            int points = recyclingItems[item]!;

            // Dynamic icon based on recycling points
            IconData icon = points > 10
                ? Icons.star
                : points > 0
                ? Icons.recycling
                : Icons.cancel;

            Color iconColor = points > 10
                ? Colors.green
                : points > 0
                ? Colors.blue
                : Colors.red;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: iconColor.withOpacity(0.2),
                  child: Icon(icon, color: iconColor),
                ),
                title: Text(
                  item,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  '$points pts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
