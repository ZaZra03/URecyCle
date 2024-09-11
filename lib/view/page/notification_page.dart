import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'dart:convert';
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

    // Ensure that loadNotifications is called after the widget has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadNotifications(); // Load notifications when the widget is built
    });
  }

  Future<void> _refreshNotifications() async {
    await Provider.of<UserProvider>(context, listen: false).loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: ListView.builder(
          itemCount: userProvider.notifications.length,
          itemBuilder: (context, index) {
            final notificationJson = userProvider.notifications[index];

            // Initialize default values
            String title = 'No Title';
            String body = 'No Body';
            String formattedTime = 'No Time';

            try {
              // Decode the notification
              final notification = json.decode(notificationJson);

              // Extract and validate fields
              title = notification['title'] ?? 'No Title';
              body = notification['body'] ?? 'No Body';

              final timestampStr = notification['timestamp'] as String?;
              if (timestampStr != null) {
                final timestamp = DateTime.parse(timestampStr).toLocal();
                formattedTime = DateFormat('MMMM d \a\t h:mm a').format(timestamp);
              } else {
                print('Timestamp is null or invalid');
              }
            } catch (e) {
              // Log the error if JSON decoding fails
              print('Error parsing notification: $e');
            }

            return Dismissible(
              key: Key(notificationJson), // Use the notification JSON or a unique ID
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                userProvider.deleteNotification(index).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$title deleted'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                });
              },
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(title),
                subtitle: Text('$body\n$formattedTime'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  print('Notification tapped: $title');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
