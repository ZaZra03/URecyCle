import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/admin_provider.dart';
import '../screen/admin_screen/binqr_screen.dart';
import '../screen/admin_screen/managebin_screen.dart';
import '../screen/admin_screen/userslist_screen.dart';
import '../screen/admin_screen/visual_screen.dart';
import '../widget/custom_card.dart';
import '../screen/admin_screen/register_screen.dart';
import '../screen/admin_screen/leaderboard_screen.dart';
// import '../../services/binstate_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    // _fetchBinState();
  }

  // Future<void> _fetchBinState() async {
  //   try {
  //     BinStateService binStateService = BinStateService();
  //     Map<String, bool>? binStates = await binStateService.getAllBinStates(); // Fetch all bin states
  //     if (binStates != null) {
  //       setState(() {
  //         Provider.of<AdminProvider>(context, listen: false).updateBinStates(binStates);
  //       });
  //     }
  //   } catch (e) {
  //     print('Error fetching bin states: $e');
  //   }
  // }

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageBinScreen(),
                ),
              );
            },
            backgroundColor: Colors.white,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.recycling, size: 48.0, color: Colors.blue),
                SizedBox(height: 8.0),
                Text('Manage Bins', style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
          CustomCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VisualMetricsScreen(),
                ),
              );
            },
            backgroundColor: Colors.white,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, size: 48.0, color: Colors.blue),
                SizedBox(height: 8.0),
                Text('Visual Metrics', style: TextStyle(fontSize: 16.0)),
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
                  builder: (context) => const LeaderboardScreen(),
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
          CustomCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BinQRScreen(),
                ),
              );
            },
            backgroundColor: Colors.white,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code, size: 48.0, color: Colors.blue),
                SizedBox(height: 8.0),
                Text('Bin QR\'s', style: TextStyle(fontSize: 16.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
