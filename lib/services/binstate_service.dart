import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import '../constants.dart';

class BinStateService {
  // Fetch all bin states
  Future<Map<String, bool>?> getAllBinStates() async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse(Constants.allBinStates), // Endpoint to fetch all bin states
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          final binStates = (data['binStates'] as List).asMap().map(
                (index, bin) => MapEntry(bin['binType'], bin['acceptingWaste']),
          );
          return binStates.map((key, value) => MapEntry(key, value as bool));
        } else {
          throw Exception('Failed to fetch bin states');
        }
      } else {
        throw Exception('Failed to fetch bin states');
      }
    } catch (e) {
      print('Error fetching bin states: $e');
      return null;
    }
  }

  // Toggle a specific bin state
  Future<void> toggleBinState(String binType, bool state) async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.patch(
        Uri.parse(Constants.toggleBinState), // Endpoint to toggle bin state
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'binType': binType, 'acceptingWaste': state}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          print('$binType state updated successfully to $state');
        } else {
          throw Exception('Failed to toggle bin state');
        }
      } else {
        throw Exception('Failed to toggle bin state');
      }
    } catch (e) {
      print('Error toggling bin state for $binType: $e');
    }
  }
}
