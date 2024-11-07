import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:urecycle_app/constants.dart';
import '../model/disposal_model.dart';
import 'auth_service.dart';

class DisposalService {
  // API endpoint for fetching total disposals
  final Uri totalDisposalsUri = Uri.parse(Constants.totalDisposals);
  final Uri allDisposalsUri = Uri.parse(Constants.allDisposals);
  final Uri weeklyDisposalsUri = Uri.parse(Constants.weeklyDisposals);

  // Fetch the total number of disposals
  Future<int> fetchTotalDisposals() async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        totalDisposalsUri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['total'] as int;
      } else {
        throw Exception('Failed to fetch total disposals: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch total disposals: $e');
    }
  }

  // Fetch all disposals
  Future<List<Disposal>> fetchAllDisposals() async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        allDisposalsUri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Disposal> disposals =
        data.map((json) => Disposal.fromJson(json)).toList();
        return disposals;
      } else {
        throw Exception('Failed to fetch all disposals: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch all disposals: $e');
    }
  }

  // Fetch weekly disposals
  Future<List<dynamic>> fetchWeeklyDisposals() async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        weeklyDisposalsUri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch weekly disposals: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch weekly disposals: $e');
    }
  }
}
