import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';
import '../services/auth_service.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final String urlNotifications = Constants.getNotification;
  bool _isListening = false;

  Future<void> initNotifications() async {
    // Request permissions for iOS
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token: $fcmToken');

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(initializationSettings);

    // Create the notification channel (for Android 8.0+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'general_notifications',  // Channel ID
      'General Notifications',   // Channel name
      description: 'This channel is used for general notifications', // Optional description
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Handle foreground messages
    if (!_isListening) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (message.notification != null) {
          final notification = message.notification!;
          print('Message data: ${message.data}');
          print('Notification: ${notification.title}, ${notification.body}');

          // Show notification
          await _localNotificationsPlugin.show(
            0,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'general_notifications',
                'General Notifications',
                icon: 'notification_icon',
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
          );
        }
      });
      _isListening = true;
    }
  }

  Future<List<dynamic>> fetchNotifications(String studentNumber) async {
    final Uri uri = Uri.parse('${Constants.getNotification}/$studentNumber');
    String? token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> deleteNotification(String studentNumber, String notificationId) async {
    final Uri uri = Uri.parse('${Constants.getNotification}/$studentNumber/$notificationId');
    String? token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete notification');
    }
  }

  Future<void> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.post(
        Uri.parse(Constants.sendNotification),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the authorization header
        },
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
      String? token = await AuthService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse(Constants.allUsers),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body)['users'];
        print('Fetched ${users.length} users.');

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
              sentTokens.add(token);
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
