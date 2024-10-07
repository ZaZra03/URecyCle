import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/admin_provider.dart';
import '../screen/userslist_screen.dart';
import '../widget/custom_card.dart';
import '../screen/register_screen.dart';
import '../screen/leaderboard_screen.dart';
import '../../services/binstate_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isAcceptingWaste = false;

  @override
  void initState() {
    super.initState();
    _fetchBinState();
  }

  Future<void> _fetchBinState() async {
    try {
      BinStateService binStateService = BinStateService();
      bool? isAcceptingWaste = await binStateService.getAcceptingWasteStatus();
      if (isAcceptingWaste != null) {
        setState(() {
          _isAcceptingWaste = isAcceptingWaste;
        });
      }
    } catch (e) {
      print('Error fetching bin state: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access AdminProvider through Provider
    final adminProvider = Provider.of<AdminProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 8.0, // Spacing between columns
        mainAxisSpacing: 8.0, // Spacing between rows
        children: <Widget>[
          CustomCard(
            onTap: () async {
              await adminProvider.toggleWasteAcceptance();
              _fetchBinState(); // Refresh the bin state after toggling
            },
            backgroundColor: adminProvider.isAcceptingWaste ? Colors.green : Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isAcceptingWaste ? Icons.check_circle : Icons.cancel,
                  size: 48.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                Text(
                  _isAcceptingWaste ? 'Accepting Waste' : 'Not Accepting',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
          ),
          // Other cards remain unchanged
          CustomCard(
            onTap: () {
              // Handle tap for Analytics card
            },
            backgroundColor: Colors.white,
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
            onTap: () async {
              await adminProvider.fetchUsers(); // Fetch the users
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserListScreen(), // Navigate to the user list screen
                ),
              );
            },
            backgroundColor: Colors.white,
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
            backgroundColor: Colors.white,
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
            backgroundColor: Colors.white,
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
