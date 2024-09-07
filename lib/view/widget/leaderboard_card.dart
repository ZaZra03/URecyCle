import 'package:flutter/material.dart';
import 'package:urecycle_app/model/user_model.dart';
import '../../model/leaderboard_model.dart';
import 'custom_card.dart';
import 'leaderboard_position.dart';

class LeaderboardCard extends StatefulWidget {
  final LeaderboardEntry? lbUser;
  final UserModel? user;
  final List<Map<String, dynamic>> top3Users;
  final VoidCallback? onTap;

  const LeaderboardCard({
    super.key,
    this.lbUser,
    this.user,
    required this.top3Users,
    this.onTap,
  });

  @override
  State createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<LeaderboardCard> {
  String _sliceName(String name) {
    final parts = name.split(' ');
    return parts.isNotEmpty ? parts[0] : name;
  }

  @override
  Widget build(BuildContext context) {
    final String initials = widget.user != null
        ? '${widget.user!.firstName[0].toUpperCase()}${widget.user!.lastName[0].toUpperCase()}'
        : '';

    final topEntries = List.generate(
      3,
          (index) => widget.top3Users.length > index ? widget.top3Users[index] : null,
      growable: false,
    );

    return CustomCard(
      onTap: widget.onTap,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Donation leaderboard',
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
                        name: _sliceName(topEntries[1]!['name']),
                        points: '${topEntries[1]!['points']} PTS',
                        color: Colors.orange,
                        isFirst: false,
                      ),
                    if (topEntries[0] != null)
                      LeaderboardPosition(
                        position: 1,
                        name: _sliceName(topEntries[0]!['name']),
                        points: '${topEntries[0]!['points']} PTS',
                        color: Colors.red,
                        isFirst: true,
                      ),
                    if (topEntries[2] != null)
                      LeaderboardPosition(
                        position: 3,
                        name: _sliceName(topEntries[2]!['name']),
                        points: '${topEntries[2]!['points']} PTS',
                        color: Colors.purpleAccent,
                        isFirst: false,
                      ),
                  ],
                ),
              ],
            ),
          ),
          UserCard(user: widget.user, lbUser: widget.lbUser, initials: initials),
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
          lbUser?.college ??
              'Loading...', // This could be user.country if you have a country field
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
