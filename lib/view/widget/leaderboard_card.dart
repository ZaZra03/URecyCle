import 'package:flutter/material.dart';
import '../../utils/userdata_utils.dart';
import 'package:urecycle_app/model/user_model.dart';
import 'package:urecycle_app/constants.dart';
import 'custom_card.dart';
import 'leaderboard_position.dart';

class LeaderboardCard extends StatefulWidget {
  final VoidCallback? onTap;

  const LeaderboardCard({super.key, this.onTap});

  @override
  State createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<LeaderboardCard> {
  UserModel? _user;
  bool _isLoading = true;
  final Uri url = Uri.parse(Constants.user); // Replace with actual user data endpoint

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await fetchUserData(url);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CustomCard(
        onTap: widget.onTap,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final initials = _user != null
        ? '${_user!.firstName[0].toUpperCase()}${_user!.lastName[0].toUpperCase()}'
        : '';

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
            'July • Global',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LeaderboardPosition(
                position: 2,
                name: 'Abdow',
                amount: '₱22,430.32',
                color: Colors.orange,
                isFirst: false,
              ),
              LeaderboardPosition(
                position: 1,
                name: 'Sneaky',
                amount: '₱35,038.82',
                color: Colors.red,
                isFirst: true,
              ),
              LeaderboardPosition(
                position: 3,
                name: '재영',
                amount: '₱22,187.88',
                color: Colors.green,
                isFirst: false,
              ),
            ],
          ),
          UserCard(user: _user, initials: initials),
        ],
      ),
    );
  }
}


class UserCard extends StatelessWidget {
  final UserModel? user;
  final String initials;

  const UserCard({super.key, this.user, required this.initials});

  @override
  Widget build(BuildContext context) {
    double avatarRadius = MediaQuery.of(context).size.width * 0.08;

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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Philippines', // This could be user.country if you have a country field
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.03,
              ),
            ),
            Text(
              '1 goal supported this month',
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.03,
              ),
            ),
          ],
        ),
        trailing: Text(
          '₱16.53',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ),
    );
  }
}