import 'package:hive/hive.dart';

part 'disposal_model_hive.g.dart';

@HiveType(typeId: 1)
class Disposal {
  @HiveField(0)
  final String wasteType;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final DateTime updatedAt;

  @HiveField(3)
  final int dayOfWeek; // New field to represent the day of the week

  Disposal({
    required this.wasteType,
    required this.createdAt,
    required this.updatedAt,
    required this.dayOfWeek,
  });

  factory Disposal.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse(json['createdAt'] ?? DateTime.now().toIso8601String()) ?? DateTime.now();
    final id = json['_id'] ?? {};
    return Disposal(
      wasteType: id['wasteType'] ?? 'Unknown', // Access nested wasteType
      createdAt: createdAt,
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? DateTime.now().toIso8601String()) ?? DateTime.now(),
      dayOfWeek: id['dayOfWeek'] ?? createdAt.weekday, // Access nested dayOfWeek
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wasteType': wasteType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dayOfWeek': dayOfWeek,
    };
  }

  @override
  String toString() {
    return 'Disposal{wasteType: $wasteType, createdAt: ${createdAt.toIso8601String()}, updatedAt: ${updatedAt.toIso8601String()}, dayOfWeek: $dayOfWeek}';
  }
}
