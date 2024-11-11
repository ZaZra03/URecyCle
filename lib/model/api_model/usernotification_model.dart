// import 'package:urecycle_app/model/api_model/pushnotification_model.dart';
//
// class UserNotificationModel {
//   final String? studentNumber;
//   final List<NotificationModel> notificationIds;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   UserNotificationModel({
//     this.studentNumber,
//     this.notificationIds = const [],
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory UserNotificationModel.fromJson(Map<String, dynamic> json) {
//     return UserNotificationModel(
//       studentNumber: json['studentNumber'],
//       notificationIds: List<NotificationModel>.from(json['notificationIds'] ?? []),
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'studentNumber': studentNumber,
//       'notificationIds': notificationIds,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }
