import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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

  Future<void> _fetchTransactions() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchTransactions(); // Make sure this is fetching the right data
  }

  Future<void> _refreshTransactions() async {
    await _fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshTransactions,
        child: ListView.builder(
          itemCount: userProvider.transactions.length + 1,
          itemBuilder: (context, index) {
            if (index == userProvider.transactions.length) {
              return const SizedBox(height: 40);
            }

            final transaction = userProvider.transactions[index];
            String date = 'No Date';
            String time = '';
            try {
              if (transaction.createdAt != null) {
                date = DateFormat('MMMM d, yyyy').format(transaction.createdAt!.toLocal());
                time = DateFormat('h:mm a').format(transaction.createdAt!.toLocal());
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
                title: Text('Type: ${transaction.wasteType}'),
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
      ),
    );
  }
}
