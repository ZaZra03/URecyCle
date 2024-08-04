import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Leaderboards',style: TextStyle(color: Colors.white),),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_vert,color: Colors.white,),
                onPressed: () {
                  // Handle more settings button press
                },
              ),
            ],
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.blue,
            flexibleSpace: const FlexibleSpaceBar(
              background: Padding(
                padding:
                EdgeInsets.only(top: 50.0), // Add top margin here
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
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
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    LeaderboardEntry(
                        rank: 1,
                        name: 'PIETRO',
                        amount: '₱29,239.47',
                        goals: 1),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    LeaderboardEntry(
                        rank: 1,
                        name: 'PIETRO',
                        amount: '₱29,239.47',
                        goals: 1),
                    LeaderboardEntry(
                        rank: 2, name: 'محمد', amount: '₱5,784.54', goals: 1),
                    LeaderboardEntry(
                        rank: 3,
                        name: 'GlenFung',
                        amount: '₱5,645.02',
                        goals: 6),
                    LeaderboardEntry(
                        rank: 1,
                        name: 'PIETRO',
                        amount: '₱29,239.47',
                        goals: 1),
                    LeaderboardEntry(
                        rank: 2, name: 'محمد', amount: '₱5,784.54', goals: 1),
                    LeaderboardEntry(
                        rank: 3,
                        name: 'GlenFung',
                        amount: '₱5,645.02',
                        goals: 6),
                    LeaderboardEntry(
                        rank: 1,
                        name: 'PIETRO',
                        amount: '₱29,239.47',
                        goals: 1),
                    LeaderboardEntry(
                        rank: 2, name: 'محمد', amount: '₱5,784.54', goals: 1),
                    LeaderboardEntry(
                        rank: 3,
                        name: 'GlenFung',
                        amount: '₱5,645.02',
                        goals: 6),
                    LeaderboardEntry(
                        rank: 1,
                        name: 'PIETRO',
                        amount: '₱29,239.47',
                        goals: 1),
                    LeaderboardEntry(
                        rank: 2, name: 'محمد', amount: '₱5,784.54', goals: 1),
                    LeaderboardEntry(
                        rank: 3,
                        name: 'GlenFung',
                        amount: '₱5,645.02',
                        goals: 6),
                    LeaderboardEntry(
                        rank: 1,
                        name: 'PIETRO',
                        amount: '₱29,239.47',
                        goals: 1),
                    LeaderboardEntry(
                        rank: 2, name: 'محمد', amount: '₱5,784.54', goals: 1),
                    LeaderboardEntry(
                        rank: 3,
                        name: 'GlenFung',
                        amount: '₱5,645.02',
                        goals: 6),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class LeaderboardPosition extends StatelessWidget {
  final int position;
  final String name;
  final String amount;
  final Color color;
  final bool isFirst;

  const LeaderboardPosition({
    super.key,
    required this.position,
    required this.name,
    required this.amount,
    required this.color,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxAvatarRadius = 60.0; // Maximum radius for the avatar
    double maxFontSize = 20.0; // Maximum font size for the position number

    double avatarRadius = isFirst
        ? ((screenWidth * 0.10 + screenHeight * 0.05) / 2).clamp(0.0, maxAvatarRadius) // Combined scaling with max constraint
        : ((screenWidth * 0.08 + screenHeight * 0.04) / 2).clamp(0.0, maxAvatarRadius);
    double fontSize = isFirst
        ? ((screenWidth * 0.07 + screenHeight * 0.03) / 2).clamp(0.0, maxFontSize) // Combined scaling with max constraint
        : ((screenWidth * 0.05 + screenHeight * 0.02) / 2).clamp(0.0, maxFontSize);

    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: color,
              child: Text(
                '$position',
                style: TextStyle(fontSize: fontSize, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: TextStyle(
            fontSize: ((screenWidth * 0.04 + screenHeight * 0.02) / 2).clamp(0.0, maxFontSize),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: ((screenWidth * 0.04 + screenHeight * 0.02) / 2).clamp(0.0, maxFontSize),
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class LeaderboardEntry extends StatelessWidget {
  final int rank;
  final String name;
  final String amount;
  final int goals;

  const LeaderboardEntry({
    super.key,
    required this.rank,
    required this.name,
    required this.amount,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(rank.toString())),
      title: Text(name),
      subtitle: Text('$goals goal${goals > 1 ? 's' : ''} supported this month'),
      trailing: Text(amount),
    );
  }
}
