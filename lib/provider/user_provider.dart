import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urecycle_app/model/user_model.dart';
import 'package:urecycle_app/model/leaderboard_model.dart';
import 'package:urecycle_app/services/firebase_service.dart';
import '../utils/lbdata_utils.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  LeaderboardEntry? _lbUser;
  List<Map<String, dynamic>> _top3Users = [];
  List<String> _notifications = [];

  UserModel? get user => _user;
  LeaderboardEntry? get lbUser => _lbUser;
  List<Map<String, dynamic>> get top3Users => _top3Users;
  List<String> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Initialize Firebase Notifications
  Future<void> initNotifications() async {
    await FirebaseApi().initNotifications(); // Move this method here
  }

  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await loadUserData();
      _user = data['user'];
      _lbUser = data['lbUser'];
      _top3Users = List<Map<String, dynamic>>.from(data['top3Users']);
    } catch (e) {
      print('Error loading user data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _user = null;
    _lbUser = null;
    _top3Users = [];
    notifyListeners();
  }

  void addNotification(String title, String body) {
    final timestamp = DateTime.now().toIso8601String(); // Get the current timestamp
    final notification = json.encode({
      'title': title,
      'body': body,
      'timestamp': timestamp,
    });

    _notifications.add(notification);
    _saveNotifications(); // Save notifications to SharedPreferences
  }

  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    _notifications = prefs.getStringList('notifications') ?? [];
    notifyListeners();
  }

  Future<void> deleteNotification(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _notifications.removeAt(index);
    await _saveNotifications(); // Save changes to SharedPreferences
    notifyListeners();
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notifications', _notifications);
    print("Notifications saved: ${_notifications.length} items"); // Add this log to confirm
  }
}
