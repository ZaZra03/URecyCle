import 'package:hive/hive.dart';

part 'reward_model_hive.g.dart';

@HiveType(typeId: 4)
class RewardModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int points;

  @HiveField(2)
  final bool available;

  @HiveField(3)
  final DateTime? createdAt;

  @HiveField(4)
  final DateTime? updatedAt;

  RewardModel({
    required this.name,
    required this.points,
    this.available = true,
    this.createdAt,
    this.updatedAt,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      name: json['name'],
      points: json['points'],
      available: json['available'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'points': points,
      'available': available,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
