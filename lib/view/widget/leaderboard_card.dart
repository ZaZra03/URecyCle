import 'package:flutter/material.dart';
import '../../model/leaderboard_model.dart';
import '../../services/leaderboard_service.dart';
import '../../utils/userdata_utils.dart';
import 'package:urecycle_app/model/user_model.dart';
import 'package:urecycle_app/constants.dart';
import 'custom_card.dart';
import 'leaderboard_position.dart';

class LeaderboardCard extends StatefulWidget {
  final VoidCallback? onTap;

  const LeaderboardCard({super.key, this.onTap});

  @override
  State createState() => LeaderboardCardState();
}

class LeaderboardCardState extends State<LeaderboardCard> {
  static LeaderboardCardState? instance; // Singleton pattern for accessing reloadData
  LeaderboardEntry? _lbUser;
  UserModel? _user;
  bool _isLoading = true;
  bool _isFirstLoad = true;  // To track if it's the first load
  List<Map<String, dynamic>>? _cachedEntries; // Cache the leaderboard entries
  final Uri _url = Uri.parse(Constants.user);

  final LeaderboardService _lbService = LeaderboardService();

  @override
  void initState() {
    super.initState();
    instance = this; // Assign this instance to the static variable
    _loadUserData();  // Load data for the first time
  }

  Future<void> _loadUserData() async {
    if (_cachedEntries != null && !_isFirstLoad) {
      // If cached data exists and it's not the first load, avoid making a request
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final user = await fetchUserData(_url);
      final lbUser = await _lbService.getEntryByStudentNumber(user?.studentNumber ?? '');
      final top3Entries = await _lbService.fetchTop3Entries();

      setState(() {
        _user = user;
        _lbUser = lbUser;
        _cachedEntries = top3Entries; // Cache the data
        _isLoading = false;
        _isFirstLoad = false;  // Set first load to false after loading data
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to reload data (used for pull-to-refresh)
  Future<void> reloadData() async {
    setState(() {
      _isLoading = true;
    });
    _cachedEntries = null; // Clear cache
    await _loadUserData();  // Trigger data reload
  }

  String _sliceName(String name) {
    final parts = name.split(' ');
    return parts.isNotEmpty ? parts[0] : name;
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
            'URECYCLE',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.grey,
            ),
          ),
          _cachedEntries != null ? _buildLeaderboardContent() : const CircularProgressIndicator(),
          UserCard(user: _user, lbUser: _lbUser, initials: initials),
        ],
      ),
    );
  }

  Widget _buildLeaderboardContent() {
    // Use _cachedEntries to build the leaderboard UI
    final topEntries = List.generate(
      3,
          (index) => _cachedEntries!.length > index ? _cachedEntries![index] : null,
      growable: false,
    );

    return Padding(
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
          lbUser?.college ?? 'Loading...', // This could be user.country if you have a country field
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
