import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../constants.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final String url1 = Constants.sendNotification;
  final String url2 = Constants.allUsers;
  bool _isListening = false;

  Future<void> initNotifications() async {
    // Request notification permissions from the user
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token: $fcmToken');

    // Avoid adding multiple listeners
    if (!_isListening) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (message.notification != null) {
          final notification = message.notification!;
          print('Message data: ${message.data}');
          print('Notification: ${notification.title}, ${notification.body}');

          // Save notification locally
          await _saveNotification(notification.title, notification.body);
        }
      });
      _isListening = true; // Mark as listening
    }
  }

  Future<void> _saveNotification(String? title, String? body) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList('notifications') ?? [];

    // Only save the notification once to prevent duplicates
    final notificationJson = json.encode({'title': title, 'body': body});
    if (!notifications.contains(notificationJson)) {
      notifications.add(notificationJson);
      await prefs.setStringList('notifications', notifications);
      print("Notification saved: $title - $body");
    } else {
      print("Notification already exists: $title - $body");
    }
  }


  Future<void> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fcmToken': fcmToken,
          'title': title,
          'body': body,
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully");
      } else {
        print("Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  Future<void> sendNotificationToAllUsers({
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      // Fetch all users
      final response = await http.get(
        Uri.parse(url2),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body)['users'];
        print('Fetched ${users.length} users.');

        // Use a Set to track already sent tokens and avoid duplicates
        final Set<String> sentTokens = <String>{};

        for (var user in users) {
          final token = user['fcmToken'];
          if (token != null && token.isNotEmpty) {
            if (!sentTokens.contains(token)) {
              print('Sending notification to token: $token');
              await sendNotification(
                fcmToken: token,
                title: title,
                body: body,
                data: data,
              );
              sentTokens.add(token);  // Add the token to the Set after sending notification
            } else {
              print('Token already processed: $token');
            }
          } else {
            print('Invalid or empty token.');
          }
        }

        print("Notifications sent to all users successfully.");
      } else {
        print("Failed to fetch users: ${response.body}");
      }
    } catch (e) {
      print("Error fetching users or sending notifications: $e");
    }
  }

}
