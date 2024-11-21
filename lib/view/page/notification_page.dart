import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../provider/user_provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchNotifications();
  }

  Future<void> _refreshNotifications() async {
    await _fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final notifications = userProvider.notifications.reversed.toList();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: ListView.separated(
          itemCount: notifications.length + 1, // Include extra space
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            if (index == notifications.length) {
              return const SizedBox(height: 40); // Extra space at the end
            }

            final notification = notifications[index];
            final notificationId = notification['_id'];
            final title = notification['title'] ?? 'No Title';
            final body = notification['body'] ?? 'No Body';

            // Parse and format 'createdAt' timestamp
            String date = 'No Date';
            String time = '';
            try {
              if (notification['createdAt'] != null) {
                final createdAt = DateTime.parse(notification['createdAt']);
                date = DateFormat('MMMM d, yyyy').format(createdAt.toLocal());
                time = DateFormat('h:mm a').format(createdAt.toLocal());
              }
            } catch (e) {
              print('Error parsing date: $e');
            }

            return Dismissible(
              key: Key(notificationId),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) async {
                // Optimistically remove notification
                setState(() {
                  userProvider.notifications.removeWhere((n) => n['_id'] == notificationId);
                });

                // Delete notification from provider
                await userProvider.deleteNotification(notificationId);

                // Show confirmation Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title deleted'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          body,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              date,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
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
