import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/hive_model/leaderboard_model_hive.dart';
import '../../model/hive_model/user_model_hive.dart';
import 'custom_card.dart';
import 'leaderboard_position.dart';
import '../../provider/user_provider.dart'; // Import your UserProvider

class LeaderboardCard extends StatelessWidget {
  final VoidCallback? onTap;

  const LeaderboardCard({super.key, this.onTap});

  String _sliceName(String name) {
    final parts = name.split(' ');
    return parts.isNotEmpty ? parts[0] : name;
  }

  @override
  Widget build(BuildContext context) {
    // Access the user and leaderboard data from the provider
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final lbUser = userProvider.lbUser;
    final top3Users = userProvider.top3Users;

    final String initials = user != null
        ? '${user.firstName[0].toUpperCase()}${user.lastName?[0].toUpperCase()}'
        : '';

    // Prepare top 3 leaderboard entries
    final topEntries = List.generate(
      3,
          (index) => top3Users.length > index ? top3Users[index] : null,
      growable: false,
    );

    return CustomCard(
      onTap: onTap,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Recycle Leaderboard',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'URECYCLE',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (topEntries[1] != null)
                      LeaderboardPosition(
                        position: 2,
                        name: _sliceName(topEntries[1]!.name),
                        points: '${topEntries[1]!.points} PTS',
                        color: Colors.orange,
                        isFirst: false,
                      ),
                    if (topEntries[0] != null)
                      LeaderboardPosition(
                        position: 1,
                        name: _sliceName(topEntries[0]!.name),
                        points: '${topEntries[0]!.points} PTS',
                        color: Colors.red,
                        isFirst: true,
                      ),
                    if (topEntries[2] != null)
                      LeaderboardPosition(
                        position: 3,
                        name: _sliceName(topEntries[2]!.name),
                        points: '${topEntries[2]!.points} PTS',
                        color: Colors.purpleAccent,
                        isFirst: false,
                      ),
                  ],
                ),
              ],
            ),
          ),
          UserCard(user: user, lbUser: lbUser, initials: initials),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserModel? user;
  final LeaderboardEntry? lbUser;
  final String initials;

  const UserCard({super.key, this.user, this.lbUser, required this.initials});

  @override
  Widget build(BuildContext context) {
    final double avatarRadius = MediaQuery.of(context).size.width * 0.08;

    return Card(
      margin: const EdgeInsets.only(top: 20),
      color: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: avatarRadius,
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.03,
            ),
          ),
        ),
        title: Text(
          user?.firstName ?? 'Loading...',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
        subtitle: Text(
          lbUser?.college ?? 'Loading...',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.03,
          ),
        ),
        trailing: Text(
          lbUser?.points.toString() ?? 'Loading...',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ),
    );
  }
}

