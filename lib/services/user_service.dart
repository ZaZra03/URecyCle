import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../model/user_model.dart';
import '../services/auth_service.dart';

class UserService {
  final Uri allUsers = Uri.parse(Constants.allUsers);

  Future<List<UserModel>> fetchUsers() async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        allUsers,
        headers: <String, String>{
          'Authorization': 'Bearer $token', // Added Authorization Bearer token
          'Content-Type': 'application/json', // Added Content-Type header
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body)['users'];
        List<UserModel> users = body.map((dynamic item) => UserModel.fromJson(item)).toList();
        return users;
      } else {
        throw Exception('Failed to load users: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}
