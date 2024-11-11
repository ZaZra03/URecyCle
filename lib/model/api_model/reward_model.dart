// class RewardModel {
//   final String name;
//   final int points;
//   final bool available;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   RewardModel({
//     required this.name,
//     required this.points,
//     this.available = true,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory RewardModel.fromJson(Map<String, dynamic> json) {
//     return RewardModel(
//       name: json['name'],
//       points: json['points'],
//       available: json['available'] ?? true,
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'points': points,
//       'available': available,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }
