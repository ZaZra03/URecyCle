// class NotificationModel {
//   final String fcmToken;
//   final String title;
//   final String body;
//   final Map<String, String> data;
//   final String status;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   NotificationModel({
//     required this.fcmToken,
//     required this.title,
//     required this.body,
//     this.data = const {},
//     this.status = 'sent',
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     return NotificationModel(
//       fcmToken: json['fcmToken'],
//       title: json['title'],
//       body: json['body'],
//       data: Map<String, String>.from(json['data'] ?? {}),
//       status: json['status'] ?? 'sent',
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'fcmToken': fcmToken,
//       'title': title,
//       'body': body,
//       'data': data,
//       'status': status,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }
