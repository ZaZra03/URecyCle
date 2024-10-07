import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import '../constants.dart';

class BinStateService {
  // Method to toggle waste acceptance
  Future<void> toggleWasteAcceptance(bool isAcceptingWaste) async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.patch(
        Uri.parse(Constants.binstate),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'acceptingWaste': isAcceptingWaste,  // Send the updated waste status
        }),
      );

      if (response.statusCode != 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update accepting waste status');
      }

      print('Waste acceptance status updated successfully');
    } catch (e) {
      print("Error toggling waste acceptance: $e");
    }
  }

  // Method to fetch the current waste acceptance status
  Future<bool?> getAcceptingWasteStatus() async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse(Constants.binstate),  // Assumes the same endpoint is used to GET the status
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Decode the JSON response
        final data = jsonDecode(response.body);
        return data['acceptingWaste'] as bool?;  // Return the acceptingWaste status
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch accepting waste status');
      }
    } catch (e) {
      print('Error fetching waste acceptance status: $e');
      return null;
    }
  }
}
