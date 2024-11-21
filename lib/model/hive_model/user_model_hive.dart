import 'package:hive/hive.dart';

part 'user_model_hive.g.dart';

@HiveType(typeId: 6)
class UserModel {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String? lastName;

  @HiveField(3)
  final String studentNumber;

  @HiveField(4)
  final String role;

  @HiveField(5)
  final String password;

  @HiveField(6)
  final String? college;

  @HiveField(7)
  final bool isFirstTimeLoggedIn;

  @HiveField(8)
  final String? fcmToken;

  UserModel({
    required this.email,
    required this.firstName,
    this.lastName,
    required this.studentNumber,
    required this.role,
    required this.password,
    required this.college,
    required this.isFirstTimeLoggedIn,
    this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      studentNumber: json['studentNumber'],
      role: json['role'],
      password: json['password'],
      college: json['college'],
      isFirstTimeLoggedIn: json['isFirstTimeLoggedIn'],
      fcmToken: json['fcmToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'studentNumber': studentNumber,
      'role': role,
      'password': password,
      'college': college,
      'isFirstTimeLoggedIn': isFirstTimeLoggedIn,
      'fcmToken': fcmToken,
    };
  }
}
