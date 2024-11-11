import 'package:hive/hive.dart';

part 'usernotification_model_hive.g.dart';

@HiveType(typeId: 7)
class UserNotificationModel {
  @HiveField(0)
  final String? studentNumber;

  @HiveField(1)
  final List<String> notificationIds;

  @HiveField(2)
  final DateTime? createdAt;

  @HiveField(3)
  final DateTime? updatedAt;

  UserNotificationModel({
    this.studentNumber,
    this.notificationIds = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) {
    return UserNotificationModel(
      studentNumber: json['studentNumber'],
      notificationIds: List<String>.from(json['notificationIds'] ?? []),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentNumber': studentNumber,
      'notificationIds': notificationIds,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
