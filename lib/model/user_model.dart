class UserModel {
  String email;
  String password;
  String firstName;
  String lastName;
  String studentNumber;

  UserModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.studentNumber,
  });

  // Convert a UserModel object into a map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'studentNumber': studentNumber,
    };
  }

  // Create a UserModel object from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      password: '', // Do not store password in Firestore for security reasons
      firstName: map['firstName'],
      lastName: map['lastName'],
      studentNumber: map['studentNumber'],
    );
  }
}
