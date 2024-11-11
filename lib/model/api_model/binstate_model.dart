// class BinStateModel {
//   final bool acceptingWaste;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   BinStateModel({
//     required this.acceptingWaste,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory BinStateModel.fromJson(Map<String, dynamic> json) {
//     return BinStateModel(
//       acceptingWaste: json['acceptingWaste'] ?? false,
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'acceptingWaste': acceptingWaste,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }
