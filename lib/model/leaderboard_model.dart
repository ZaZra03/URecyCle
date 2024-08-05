class LeaderboardEntry {
  final String name;
  final String department;
  final int points;

  LeaderboardEntry({
    required this.name,
    required this.department,
    required this.points,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      name: json['name'],
      department: json['department'],
      points: json['points'],
    );
  }
}
