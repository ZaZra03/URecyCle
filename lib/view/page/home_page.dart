import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../../utils/navigation_utils.dart';
import '../screen/leaderboard_screen.dart';
import '../screen/mission_vision_screen.dart';
import '../screen/sgd_screen.dart';
import '../screen/user_screen.dart';
import '../widget/leaderboard_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    // Ensure that fetchUserData is called after the widget has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user == null || userProvider.lbUser == null) {
        userProvider.fetchUserData();
      }
      userProvider.fetchTotalDisposals();
    });
  }

  Future<void> _refreshData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserData();

    if (mounted) {
      await userProvider.fetchTotalDisposals();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalDisposals = Provider.of<UserProvider>(context).totalDisposals.toString();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              LeaderboardCard(
                onTap: () => handleTap(context, const LeaderboardPage()),
              ),
              _buildInfoCard(
                title: 'Total Disposed Recycled Waste',
                value: totalDisposals,
                buttonText: 'Recycle',
                onButtonPressed: () {
                  setState(() {
                    final userScreenState = context.findAncestorStateOfType<UserScreenState>();
                    if (userScreenState != null) {
                      userScreenState.setSelectedIndex(2);
                      userScreenState.pageController.jumpToPage(2);
                    }
                  });
                },
              ),
              _buildImageCard(
                imagePath: 'assets/images/SGD_12.png',
                title: 'Sustainable Development Goal 12',
                subtitle:
                    'Learn more about how SDG 12 fosters sustainable practices.',
                onButtonPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SGDScreen(),
                    ),
                  );
                },
              ),
              _buildImageCard(
                imagePath: 'assets/images/MNV.jpg',
                title: 'Mission and Vision',
                subtitle: 'Discover the University Mission and Vision.',
                onButtonPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MissionVisionScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 110),
            ],
          ),
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
