// class TransactionModel {
//   final String studentNumber;
//   final String wasteType;
//   final int pointsEarned;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   TransactionModel({
//     required this.studentNumber,
//     required this.wasteType,
//     required this.pointsEarned,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory TransactionModel.fromJson(Map<String, dynamic> json) {
//     return TransactionModel(
//       studentNumber: json['studentNumber'],
//       wasteType: json['wasteType'],
//       pointsEarned: json['pointsEarned'],
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'studentNumber': studentNumber,
//       'wasteType': wasteType,
//       'pointsEarned': pointsEarned,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }
