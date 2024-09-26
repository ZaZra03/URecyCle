import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/user_model.dart';

class UserService {
  final Uri allUsers = Uri.parse(Constants.allUsers);

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(allUsers);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['users'];
      List<UserModel> users = body.map((dynamic item) => UserModel.fromJson(item)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
