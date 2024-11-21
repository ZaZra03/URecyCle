import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:urecycle_app/constants.dart';
import '../services/auth_service.dart';

class TransactionService {
  // API endpoints
  final Uri createTransactionUri = Uri.parse(Constants.createTransaction);

  // Create a new transaction
  Future<void> createTransaction(String studentNumber, String wasteType, int pointsEarned) async {
    try {
      String? token = await AuthService.getToken();  // Get the auth token
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.post(
        createTransactionUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',  // Add authorization header
        },
        body: jsonEncode({
          'studentNumber': studentNumber,
          'wasteType': wasteType,
          'pointsEarned': pointsEarned,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create transaction: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  // Fetch transactions by student number
  Future<List<Map<String, dynamic>>> fetchTransactionsByStudentNumber(String studentNumber) async {
    final Uri studentTransactionsUri = Uri.parse('$createTransactionUri/$studentNumber');

    try {
      String? token = await AuthService.getToken();  // Get the auth token
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        studentTransactionsUri,
        headers: {
          'Authorization': 'Bearer $token',  // Add authorization header
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to fetch transactions: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }
}
