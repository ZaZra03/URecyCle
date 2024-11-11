import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../model/hive_model/user_model_hive.dart';
import 'auth_service.dart';

class UserService {
  final Uri allUsers = Uri.parse(Constants.allUsers);

  Future<List<UserModel>> fetchUsers() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      allUsers,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['users'];
      List<UserModel> users =
          body.map((dynamic item) => UserModel.fromJson(item)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
