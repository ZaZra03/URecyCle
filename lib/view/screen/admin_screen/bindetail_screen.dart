import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../provider/admin_provider.dart';

class BinDetailsScreen extends StatelessWidget {
  final String binId;

  const BinDetailsScreen({super.key, required this.binId});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bin Details: $binId',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: Future.wait([
          adminProvider.fetchTransactionsByWasteType(binId),
          adminProvider.fetchTotalPointsByWasteType(binId),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching details: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }

          return Consumer<AdminProvider>(
            builder: (context, provider, child) {
              final transactions = provider.transactionsByWasteType;
              final totalPoints = provider.totalPointsByWasteType;

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total Points for $binId: $totalPoints',
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Text(
                    'Transactions:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  ...transactions.map((transaction) {
                    return ListTile(
                      leading: Icon(Icons.recycling, color: Constants.primaryColor),
                      title: Text('Student Number: ${transaction['studentNumber']}'),
                      subtitle: Text('Points Earned: ${transaction['pointsEarned']}'),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
