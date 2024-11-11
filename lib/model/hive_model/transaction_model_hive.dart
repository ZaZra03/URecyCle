import 'package:hive/hive.dart';

part 'transaction_model_hive.g.dart';

@HiveType(typeId: 5)
class TransactionModel {
  @HiveField(0)
  final String studentNumber;

  @HiveField(1)
  final String wasteType;

  @HiveField(2)
  final int pointsEarned;

  @HiveField(3)
  final DateTime? createdAt;

  @HiveField(4)
  final DateTime? updatedAt;

  TransactionModel({
    required this.studentNumber,
    required this.wasteType,
    required this.pointsEarned,
    this.createdAt,
    this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      studentNumber: json['studentNumber'],
      wasteType: json['wasteType'],
      pointsEarned: json['pointsEarned'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentNumber': studentNumber,
      'wasteType': wasteType,
      'pointsEarned': pointsEarned,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
