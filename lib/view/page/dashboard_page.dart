import 'package:flutter/material.dart';
import '../widget/custom_card.dart';
import 'package:urecycle_app/view/register_screen.dart';
import '../leaderboard_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Manage the state of the waste acceptance toggle
  bool isAcceptingWaste = false; // Initially, not accepting

  void _toggleWasteAcceptance() {
    setState(() {
      isAcceptingWaste = !isAcceptingWaste; // Toggle the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 8.0, // Spacing between columns
        mainAxisSpacing: 8.0, // Spacing between rows
        children: <Widget>[
          CustomCard(
            onTap: _toggleWasteAcceptance, // Toggle state on tap
            backgroundColor: isAcceptingWaste ? Colors.green : Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isAcceptingWaste ? Icons.check_circle : Icons.cancel,
                  size: 48.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                Text(
                  isAcceptingWaste ? 'Accepting Waste' : 'Not Accepting',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
          ),
          CustomCard(
            onTap: () {
              // Handle tap for Analytics card
            },
            backgroundColor: Colors.white, // Default color
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, size: 48.0, color: Colors.blue),
                SizedBox(height: 8.0),
                Text('Analytics', style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
          CustomCard(
            onTap: () {
              // Handle tap for View Users card
            },
            backgroundColor: Colors.white, // Default color
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 48.0, color: Colors.blue),
                SizedBox(height: 8.0),
                Text('View Users', style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
          CustomCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegistrationScreen(),
                ),
              );
            },
            backgroundColor: Colors.white, // Default color
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add, size: 48.0, color: Colors.blue),
                SizedBox(height: 8.0),
                Text('Create Users', style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
          CustomCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaderboardPage(),
                ),
              );
            },
            backgroundColor: Colors.white, // Default color
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.leaderboard, size: 48.0, color: Colors.blue),
                SizedBox(height: 8.0),
                Text('Leaderboards', style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
