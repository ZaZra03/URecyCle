import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import '../../provider/user_provider.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: userProvider.transactions.length + 1,
        itemBuilder: (context, index) {
          if (index == userProvider.transactions.length) {
            return const SizedBox(height: 40);
          }

          final transaction = userProvider.transactions[index];
          String date = 'No Date';
          String time = '';
          try {
            if (transaction['createdAt'] != null) {
              final createdAt = DateTime.parse(transaction['createdAt']);
              date = DateFormat('MMMM d, yyyy').format(createdAt.toLocal());
              time = DateFormat('h:mm a').format(createdAt.toLocal());
            }
          } catch (e) {
            print('Error parsing date: $e');
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              title: Text('Type: ${transaction['wasteType']}'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: $date',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      'Time: $time',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
