import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../model/user_model.dart';
import '../../services/firebase_service.dart';
import '../constants.dart';

class AdminProvider with ChangeNotifier {
  bool isAcceptingWaste = false;
  UserModel? _user;
  List<UserModel> _users = [];
  final FirebaseApi _firebaseApi = FirebaseApi();
  final UserService _userService = UserService();

  UserModel? get user => _user;
  List<UserModel> get users => _users;  // Add getter for users

  AdminProvider() {
    _firebaseApi.initNotifications();
  }

  Future<void> fetchAdminData() async {
    try {
      _user = await fetchUserData(Uri.parse(Constants.user));
      notifyListeners();
    } catch (e) {
      print('Error loading admin data: $e');
    }
  }

  Future<void> fetchUsers() async {
    try {
      _users = await _userService.fetchUsers();
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void toggleWasteAcceptance() async {
    isAcceptingWaste = !isAcceptingWaste;
    notifyListeners();

    String title = 'URecyCle';
    String body = isAcceptingWaste
        ? 'Recycling Bin Ready: It\'s time to drop off your recyclables!'
        : 'Recycling Bin Closed: Please wait for the next cycle.';

    try {
      await _firebaseApi.sendNotificationToAllUsers(
        title: title,
        body: body,
      );
      print("Notification sent to all users.");
    } catch (e) {
      print("Error sending notifications: $e");
    }
  }

  void reset() {
    _user = null;
    _users = [];
    notifyListeners();
  }
}
