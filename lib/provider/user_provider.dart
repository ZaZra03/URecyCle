import 'package:flutter/material.dart';
import 'package:urecycle_app/model/user_model.dart';
import 'package:urecycle_app/model/leaderboard_model.dart';
import 'package:urecycle_app/services/firebase_service.dart';
import 'package:urecycle_app/services/leaderboard_service.dart';
import '../utils/lbdata_utils.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  LeaderboardEntry? _lbUser;
  List<Map<String, dynamic>> _top3Users = [];
  List<dynamic> _notifications = [];
  bool _isLoading = false;

  UserModel? get user => _user;
  LeaderboardEntry? get lbUser => _lbUser;
  List<Map<String, dynamic>> get top3Users => _top3Users;
  List<dynamic> get notifications => _notifications;
  bool get isLoading => _isLoading;

  final FirebaseApi _firebaseApi = FirebaseApi();

  Future<void> initNotifications() async {
    await _firebaseApi.initNotifications();
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

  Future<void> fetchNotifications() async {
    try {
      _notifications = await _firebaseApi.fetchNotifications(_user!.studentNumber);
      notifyListeners();
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firebaseApi.deleteNotification(_user!.studentNumber, notificationId);
      _notifications.removeWhere((notification) => notification['_id'] == notificationId);
      notifyListeners();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  void clearData() {
    _user = null;
    _lbUser = null;
    _top3Users = [];
    notifyListeners();
  }
}
