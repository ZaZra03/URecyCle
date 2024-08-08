class UserModel {
  final String email;
  final String firstName;
  final String lastName;
  final String studentNumber;
  final String role;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.studentNumber,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      studentNumber: json['studentNumber'],
      role: json['role'],
    );
  }
}