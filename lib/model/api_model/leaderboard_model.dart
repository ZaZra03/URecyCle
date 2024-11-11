// class LeaderboardEntry {
//   final String name;
//   final String studentNumber;
//   final String college;
//   final int points;
//
//   LeaderboardEntry({
//     required this.name,
//     required this.studentNumber,
//     required this.college,
//     required this.points,
//   });
//
//   factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
//     return LeaderboardEntry(
//       name: json['name'],
//       studentNumber: json['studentNumber'],
//       college: json['college'],
//       points: json['points'] is int ? json['points'] : int.tryParse(json['points']) ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'studentNumber': studentNumber,
//       'college': college,
//       'points': points,
//     };
//   }
// }
