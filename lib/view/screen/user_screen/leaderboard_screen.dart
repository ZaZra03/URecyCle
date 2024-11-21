import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urecycle_app/view/widget/leaderboard_position2.dart';
import '../../../constants.dart';
import '../../../provider/user_provider.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  String _sliceName(String? name) {
    if (name == null) return '';
    final parts = name.split(' ');
    return parts.isNotEmpty ? parts[0] : name;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Ensure the leaderboard data is fetched
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider.fetchLeaderboardEntries();
    });

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
            expandedHeight: 275.0,
            floating: false,
            pinned: true,
            backgroundColor: Constants.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Consumer<UserProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (provider.top3Users.isEmpty) {
                    return const Center(child: Text('No leaderboard entries found.'));
                  } else {
                    final topEntries = provider.top3Users;

                    return Padding(
                      padding: const EdgeInsets.only(top: 120.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (topEntries.length > 1)
                            LeaderboardPosition(
                              position: 2,
                              name: _sliceName(topEntries[1].name),
                              points: '${topEntries[1].points} PTS',
                              color: Colors.orange,
                              isFirst: false,
                            ),
                          if (topEntries.isNotEmpty)
                            LeaderboardPosition(
                              position: 1,
                              name: _sliceName(topEntries[0].name),
                              points: '${topEntries[0].points} PTS',
                              color: Colors.red,
                              isFirst: true,
                            ),
                          if (topEntries.length > 2)
                            LeaderboardPosition(
                              position: 3,
                              name: _sliceName(topEntries[2].name),
                              points: '${topEntries[2].points} PTS',
                              color: Colors.purpleAccent,
                              isFirst: false,
                            ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Consumer<UserProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (provider.leaderboards.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No leaderboard entries found.')),
                );
              } else {
                final entries = provider.leaderboards;
                final studentNumber = provider.lbUser?.studentNumber;

                // Find the user's rank dynamically
                final userRank = entries.indexWhere(
                      (entry) => entry.studentNumber == studentNumber,
                ) +
                    1; // Ranks are 1-based
                final userEntry = userRank > 0 ? entries[userRank - 1] : null;

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      // Show user's entry at the top
                      if (index == 0 && userEntry != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            tileColor: Colors.blueAccent.withOpacity(0.2),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              child: Text(userRank.toString()),
                            ),
                            title: Text(
                              _sliceName(userEntry.name),
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              _sliceName(userEntry.college),
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              '${userEntry.points} PTS',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }

                      // Offset by 1 to skip user's entry
                      final adjustedIndex = userEntry != null ? index - 1 : index;
                      if (adjustedIndex < 0 || adjustedIndex >= entries.length) {
                        return null;
                      }
                      final entry = entries[adjustedIndex];
                      final rank = adjustedIndex + 1;

                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(child: Text(rank.toString())),
                            title: Text(entry.name),
                            subtitle: Text(entry.college),
                            trailing: Text('${entry.points} PTS'),
                          ),
                          const Divider(), // Divider added after each entry
                        ],
                      );
                    },
                    childCount: entries.length + (userEntry != null ? 1 : 0),
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
