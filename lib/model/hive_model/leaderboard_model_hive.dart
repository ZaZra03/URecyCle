import 'package:hive/hive.dart';

part 'leaderboard_model_hive.g.dart';

@HiveType(typeId: 2)
class LeaderboardEntry {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String studentNumber;

  @HiveField(2)
  final String college;

  @HiveField(3)
  final int points;

  LeaderboardEntry({
    required this.name,
    required this.studentNumber,
    required this.college,
    required this.points,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      name: json['name'],
      studentNumber: json['studentNumber'],
      college: json['college'],
      points: json['points'] is int ? json['points'] : int.tryParse(json['points']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'studentNumber': studentNumber,
      'college': college,
      'points': points,
    };
  }
}
