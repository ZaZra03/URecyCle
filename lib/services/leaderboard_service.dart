import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:urecycle_app/constants.dart'; // Update this import path if necessary

class LeaderboardService {
  // Fetch leaderboard entries from the server
  Future<List<Map<String, dynamic>>> fetchLeaderboardEntries() async {
    final Uri url = Uri.parse(Constants.leaderboard);

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

  // Create a new leaderboard entry
  // Future<Map<String, dynamic>> createLeaderboardEntry({
  //   required String name,
  //   required String department,
  //   required int points,
  // }) async {
  //   final Uri url = Uri.parse(Constants.leaderboard); // URL for creating entries
  //
  //   // Print the URL and payload for debugging
  //   print('Create Leaderboard Entry URL: $url');
  //   print('Create Leaderboard Entry Payload: ${jsonEncode({
  //     'name': name,
  //     'department': department,
  //     'points': points,
  //   })}');
  //
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode({
  //         'name': name,
  //         'department': department,
  //         'points': points,
  //       }),
  //     );
  //
  //     // Print the response status code and body for debugging
  //     print('Create Leaderboard Entry Response Status Code: ${response.statusCode}');
  //     print('Create Leaderboard Entry Response Body: ${response.body}');
  //
  //     if (response.statusCode == 201) {
  //       return jsonDecode(response.body);
  //     } else {
  //       final Map<String, dynamic> errorResponse = jsonDecode(response.body);
  //       final String errorMessage = errorResponse['error'] ?? 'Failed to create leaderboard entry';
  //       throw Exception(errorMessage);
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to create leaderboard entry: $e');
  //   }
  // }
}
