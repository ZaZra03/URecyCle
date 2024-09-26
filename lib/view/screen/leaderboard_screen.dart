import 'package:flutter/material.dart';
import 'package:urecycle_app/services/leaderboard_service.dart';
import 'package:urecycle_app/view/widget/leaderboard_position2.dart';

import '../constants.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  String _sliceName(String name) {
    final parts = name.split(' ');
    return parts.isNotEmpty ? parts[0] : name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Leaderboards',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Handle more settings button press
                },
              ),
            ],
            expandedHeight: 275.0,
            floating: false,
            pinned: true,
            backgroundColor: Constants.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: FutureBuilder<List<Map<String, dynamic>>>(
                future: LeaderboardService().fetchTop3Entries(),
                builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No leaderboard entries found.'));
                  } else {
                    final entries = snapshot.data!;

                    // Ensure you have at least 3 entries to avoid index errors
                    final topEntries = List.generate(
                      3,
                          (index) => entries.length > index ? entries[index] : null,
                      growable: false,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(top: 50.0),
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
                },
              ),
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: LeaderboardService().fetchLeaderboardEntries(),
            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No leaderboard entries found.')),
                );
              } else {
                final entries = snapshot.data!;

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final entry = entries[index];
                      final rank = index + 1;
                      return LeaderboardEntry(
                        rank: rank,
                        name: entry['name'],
                        college: entry['college'],
                        points: entry['points'],
                      );
                    },
                    childCount: entries.length,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class LeaderboardEntry extends StatelessWidget {
  final int rank;
  final String name;
  final String college;
  final int points;

  const LeaderboardEntry({
    super.key,
    required this.rank,
    required this.name,
    required this.college,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(rank.toString())),
      title: Text(name),
      subtitle: Text(college),
      trailing: Text(points.toString()),
    );
  }
}
