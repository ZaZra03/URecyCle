import 'package:hive/hive.dart';

part 'pushnotification_model_hive.g.dart';

@HiveType(typeId: 3)
class NotificationModel {
  @HiveField(0)
  final String fcmToken;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final Map<String, String> data;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final DateTime? createdAt;

  @HiveField(6)
  final DateTime? updatedAt;

  NotificationModel({
    required this.fcmToken,
    required this.title,
    required this.body,
    this.data = const {},
    this.status = 'sent',
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      fcmToken: json['fcmToken'],
      title: json['title'],
      body: json['body'],
      data: Map<String, String>.from(json['data'] ?? {}),
      status: json['status'] ?? 'sent',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fcmToken': fcmToken,
      'title': title,
      'body': body,
      'data': data,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
