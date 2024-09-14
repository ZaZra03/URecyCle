class UserModel {
  final String email;
  final String firstName;
  final String lastName;
  final String studentNumber;
  final String role;
  final String password;
  final String? college;
  final String? fcmToken;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.studentNumber,
    required this.role,
    required this.password,
    required this.college,
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
      'fcmToken': fcmToken,
    };
  }
}
