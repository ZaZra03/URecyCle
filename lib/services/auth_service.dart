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

  Future<void> logout() async {
    // Optionally, notify backend about the logout if your backend supports this
    final Uri logoutUrl = Uri.parse(Constants.logoutUrl); // Define this in your constants
    final token = await getToken();

    if (token != null) {
      try {
        final response = await http.post(
          logoutUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          // Successful response from backend
          await deleteToken();
        } else {
          // Handle server error or invalid response
          print('Failed to logout. Server response: ${response.statusCode}');
          await deleteToken(); // Still clear token if server is unreachable
        }
      } catch (e) {
        print('Error during logout: $e');
        await deleteToken(); // Clear token in case of any error
      }
    } else {
      await deleteToken(); // Clear token if no token is found
    }
  }
}
