import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:urecycle_app/constants.dart';

class DisposalService {
  // API endpoint for fetching total disposals
  final Uri totalDisposalsUri = Uri.parse(Constants.totalDisposals);

  // Fetch the total number of disposals
  Future<int> fetchTotalDisposals() async {
    try {
      final response = await http.get(totalDisposalsUri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['total'] as int; // Return the total from the response
      } else {
        throw Exception('Failed to fetch total disposals: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch total disposals: $e');
    }
  }
}