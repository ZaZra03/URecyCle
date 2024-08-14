import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:urecycle_app/constants.dart';

import '../model/leaderboard_model.dart'; // Update this import path if necessary

class LeaderboardService {
  // Fetch leaderboard entries from the server
  final Uri url = Uri.parse(Constants.leaderboard);
  Future<List<Map<String, dynamic>>> fetchLeaderboardEntries() async {


    // Print the URL for debugging
    print('Leaderboard URL: $url');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Print the response status code and body for debugging
      print('Leaderboard Response Status Code: ${response.statusCode}');
      print('Leaderboard Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // Convert data to a list of maps
        return List<Map<String, dynamic>>.from(data);
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['error'] ?? 'Failed to fetch leaderboard entries';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to fetch leaderboard entries: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchTop3Entries() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }

  Future<LeaderboardEntry?> getEntryByStudentNumber(String studentNumber) async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> entries = jsonDecode(response.body);
        final entryMap = entries.firstWhere(
              (entry) => entry['studentNumber'] == studentNumber,
          orElse: () => null,
        );

        if (entryMap != null) {
          return LeaderboardEntry.fromJson(entryMap);
        } else {
          print('Entry not found');
          return null;
        }
      } else if (response.statusCode == 404) {
        print('Entry not found');
        return null;
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching entry: $error');
      return null;
    }
  }
}
