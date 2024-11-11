// class Disposal {
//   final String id;
//   final String wasteType;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   Disposal({
//     required this.id,
//     required this.wasteType,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Disposal.fromJson(Map<String, dynamic> json) {
//     return Disposal(
//       id: json['id'] ?? '', // Default to an empty string if null
//       wasteType: json['wasteType'] ?? 'Unknown', // Default to 'Unknown' if null
//       createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()), // Fallback to current time
//       updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()), // Fallback to current time
//     );
//   }
//
//   @override
//   String toString() {
//     return 'Disposal{id: $id, wasteType: $wasteType, createdAt: ${createdAt.toIso8601String()}, updatedAt: ${updatedAt.toIso8601String()}}';
//   }
// }
