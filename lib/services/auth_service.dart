import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:urecycle_app/constants.dart';

class AuthService {
  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String studentNumber, // Change this from studentID to studentNumber
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse(Constants.register);

    print('Register URL: $url');
    print('Register Payload: ${jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'studentNumber': studentNumber, // Updated field name
      'email': email,
      'password': password,
    })}');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'studentNumber': studentNumber, // Updated field name
          'email': email,
          'password': password,
        }),
      );

      print('Register Response Status Code: ${response.statusCode}');
      print('Register Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['error'] ?? 'Failed to register';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }


  Future<Map<String, dynamic>> loginUser({
    required String studentNumber,
    required String password,
  }) async {
    final Uri url = Uri.parse(Constants.login);

    // Print the URL and payload for debugging
    print('Login URL: $url');
    print('Login Payload: ${jsonEncode({
      'studentNumber': studentNumber,
      'password': password,
    })}');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'studentNumber': studentNumber,
          'password': password,
        }),
      );

      // Print the response status code and body for debugging
      print('Login Response Status Code: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['message'] ?? 'Failed to login';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
