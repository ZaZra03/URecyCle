import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/services/auth_service.dart';
import '../model/leaderboard_model.dart';

class LeaderboardService {
  // URLs for API endpoints
  final Uri leaderboard = Uri.parse(Constants.leaderboard);
  final Uri lbTop3 = Uri.parse(Constants.lbTop3);

  // Fetch all leaderboard entries from the server
  Future<List<Map<String, dynamic>>> fetchLeaderboardEntries() async {
    print('Leaderboard URL: $leaderboard'); // Debugging

    try {
      final response = await http.get(
        leaderboard,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Leaderboard Response Status Code: ${response.statusCode}');
      print('Leaderboard Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data); // Convert data to a list of maps
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['error'] ?? 'Failed to fetch leaderboard entries';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to fetch leaderboard entries: $e');
    }
  }

  // Fetch top 3 leaderboard entries from the server
  Future<List<Map<String, dynamic>>> fetchTop3Entries() async {
    print('Top 3 URL: $lbTop3'); // Debugging

    try {
      final response = await http.get(
        lbTop3,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Top 3 Response Status Code: ${response.statusCode}');
      print('Top 3 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data); // Convert data to a list of maps
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['error'] ?? 'Failed to fetch top 3 leaderboard entries';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to fetch top 3 leaderboard entries: $e');
    }
  }

  // Fetch a specific leaderboard entry by student number from the server
  Future<LeaderboardEntry?> getEntryByStudentNumber(String studentNumber) async {
    final Uri userUri = Uri.parse('${Constants.leaderboard}/$studentNumber');
    print('User URL: $userUri'); // Debugging

    try {
      final response = await http.get(
        userUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('User Response Status Code: ${response.statusCode}');
      print('User Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return LeaderboardEntry.fromJson(data); // Convert the response to a LeaderboardEntry object
      } else if (response.statusCode == 404) {
        print('Entry not found');
        return null;
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['error'] ?? 'Failed to fetch user entry';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to fetch user entry: $e');
    }
  }

  // Add points to a specific leaderboard entry by student number
  Future<void> addPointsToUser(String studentNumber) async {
    final Uri addPointsUri = Uri.parse('${Constants.leaderboard}/$studentNumber/add-points');
    print('Add Points URL: $addPointsUri'); // Debugging

    try {
      final response = await http.post(
        addPointsUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          // Add the fixed points here if required by the backend
        }),
      );

      print('Add Points Response Status Code: ${response.statusCode}');
      print('Add Points Response Body: ${response.body}');

      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['error'] ?? 'Failed to add points';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to add points: $e');
    }
  }

  Future<void> deductPointsFromUser(String studentNumber, int pointsToDeduct) async {
    final Uri deductPointsUri = Uri.parse('${Constants.leaderboard}/$studentNumber/deduct-points');
    print('Deduct Points URL: $deductPointsUri'); // Debugging

    try {
      final response = await http.post(
        deductPointsUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'pointsToDeduct': pointsToDeduct,
        }),
      );

      print('Deduct Points Response Status Code: ${response.statusCode}');
      print('Deduct Points Response Body: ${response.body}');

      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['error'] ?? 'Failed to deduct points';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to deduct points: $e');
    }
  }

  Future<Map<String, dynamic>> loadUserData() async {
    final LeaderboardService lbService = LeaderboardService();
    final Uri url = Uri.parse(Constants.user);

    try {
      final user = await fetchUserData(url);
      final lbUser = await lbService.getEntryByStudentNumber(user?.studentNumber ?? '');
      final top3Users = await lbService.fetchTop3Entries();

      return {
        'user': user,
        'lbUser': lbUser,
        'top3Users': top3Users,
      };
    } catch (e) {
      print('Error loading user data: $e');
      rethrow;
    }
  }
}


