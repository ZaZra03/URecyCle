import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/model/user_model.dart';

class AuthService {
  // Store token locally in shared preferences
  static Future<void> storeToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Retrieve token from shared preferences
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Delete token from shared preferences
  static Future<void> deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Register a new user and store the token
  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String studentNumber,
    required String college,
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse(Constants.register);

    try {
      // Retrieve FCM token
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      final String? fcmToken = await firebaseMessaging.getToken();

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
          'fcmToken': fcmToken, // Send FCM token to backend
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
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

  // Login a user and store the token
  Future<Map<String, dynamic>> loginUser({
    required String studentNumber,
    required String password,
  }) async {
    final Uri url = Uri.parse(Constants.login);

    try {
      // Retrieve FCM token
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      final String? fcmToken = await firebaseMessaging.getToken();

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'studentNumber': studentNumber,
          'password': password,
          'fcmToken': fcmToken, // Send FCM token to backend
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String? token = responseData['token'];
        if (token != null) {
          await storeToken(token);
        }
        return responseData;
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['error'] ?? 'Failed to login';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Logout the user by deleting the stored token
  Future<void> logout() async {
    final String? tokenBefore = await getToken();
    print('Token before deletion: $tokenBefore');

    await deleteToken();

    final String? tokenAfter = await getToken();
    print('Token after deletion: $tokenAfter');

    if (tokenAfter == null) {
      print('Token successfully deleted.');
    } else {
      print('Token deletion failed.');
    }
  }
}

// Fetch user data from the server using the stored token
Future<UserModel?> fetchUserData(Uri url) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception('Failed to load user data');
    }
  } catch (e) {
    throw Exception('Error fetching user data: $e');
  }
}
