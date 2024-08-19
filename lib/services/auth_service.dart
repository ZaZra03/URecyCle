import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:urecycle_app/constants.dart';

class AuthService {
  static Future<void> storeToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String studentNumber,
    required String college,
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse(Constants.register);

    // print('Register URL: $url');
    // print('Register Payload: ${jsonEncode({
    //   'firstName': firstName,
    //   'lastName': lastName,
    //   'studentNumber': studentNumber,
    //   'email': email,
    //   'password': password,
    // })}');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'studentNumber': studentNumber,
          'college': college,
          'email': email,
          'password': password,
        }),
      );

      // print('Register Response Status Code: ${response.statusCode}');
      // print('Register Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // Optionally, store the token here if available in the response
        final String? token = responseData['token'];
        if (token != null) {
          await storeToken(token);
        }
        return responseData;
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

    // print('Login URL: $url');
    // print('Login Payload: ${jsonEncode({
    //   'studentNumber': studentNumber,
    //   'password': password,
    // })}');

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

      print('Login Response Status Code: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Store the token received from the response
        final String? token = responseData['token'];
        if (token != null) {
          await storeToken(token);
        }
        return responseData;
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['message'] ?? 'Failed to login';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    // Debug: Print token before deletion
    final String? tokenBefore = await getToken();
    print('Token before deletion: $tokenBefore');

    // Perform token deletion
    await deleteToken();

    // Debug: Print token after deletion
    final String? tokenAfter = await getToken();
    print('Token after deletion: $tokenAfter');

    // Optionally, you can check if the token is null after deletion
    if (tokenAfter == null) {
      print('Token successfully deleted.');
    } else {
      print('Token deletion failed.');
    }
  }

}
