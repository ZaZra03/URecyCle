import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:urecycle_app/constants.dart';

class TransactionService {
  // API endpoints
  final Uri createTransactionUri = Uri.parse(Constants.createTransaction);

  // Create a new transaction
  Future<void> createTransaction(String studentNumber, String wasteType, int pointsEarned) async {
    try {
      final response = await http.post(
        createTransactionUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
      final response = await http.get(studentTransactionsUri);

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


