import 'package:hive/hive.dart';

part 'disposal_model_hive.g.dart';

@HiveType(typeId: 1)
class Disposal {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String wasteType;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime updatedAt;

  Disposal({
    required this.id,
    required this.wasteType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Disposal.fromJson(Map<String, dynamic> json) {
    return Disposal(
      id: json['id'] ?? '', // Default to an empty string if null
      wasteType: json['wasteType'] ?? 'Unknown', // Default to 'Unknown' if null
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()), // Fallback to current time
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()), // Fallback to current time
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wasteType': wasteType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Disposal{id: $id, wasteType: $wasteType, createdAt: ${createdAt.toIso8601String()}, updatedAt: ${updatedAt.toIso8601String()}}';
  }
}
