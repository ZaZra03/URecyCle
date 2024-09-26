import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for trash disposal transactions
    final List<Map<String, String>> transactions = [
      {'description': 'Successfully disposed waste', 'date': 'August 1, 2024'},
      {'description': 'Successfully disposed waste', 'date': 'August 5, 2024'},
      {'description': 'Successfully disposed waste', 'date': 'August 12, 2024'},
      {'description': 'Successfully disposed waste', 'date': 'August 15, 2024'},
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              title: Text(transaction['description']!),
              subtitle: Text(transaction['date']!),
            ),
          );
        },
      ),
    );
  }
}
