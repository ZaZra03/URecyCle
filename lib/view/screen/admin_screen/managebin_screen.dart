import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../provider/admin_provider.dart';
import 'bindetail_screen.dart';

class ManageBinScreen extends StatelessWidget {
  const ManageBinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Bins',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: adminProvider.fetchBinStates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading bin states: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }

          return Consumer<AdminProvider>(
            builder: (context, provider, child) {
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: provider.binStates.entries.map((entry) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  entry.value ? 'Status: Open' : 'Status: Closed',
                                  style: TextStyle(
                                    color: entry.value ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Switch(
                                value: entry.value,
                                onChanged: (newValue) async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );

                                  try {
                                    await provider.toggleBinState(entry.key);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error toggling state: $e')),
                                    );
                                  } finally {
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BinDetailsScreen(binId: entry.key),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.info,
                                  size: 18.0,
                                  color: Colors.white, // Set icon color to white
                                ),
                                label: const Text(
                                  'Details',
                                  style: TextStyle(color: Colors.white), // Set text color to white
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primaryColor, // Button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
