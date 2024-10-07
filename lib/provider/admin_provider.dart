import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../model/user_model.dart';
import '../../services/firebase_service.dart';
import '../constants.dart';
import '../services/binstate_service.dart';

class AdminProvider with ChangeNotifier {
  bool _isAcceptingWaste = false;
  UserModel? _user;
  List<UserModel> _users = [];
  final FirebaseApi _firebaseApi = FirebaseApi();
  final BinStateService _binStateService = BinStateService();

  // Getters for accessing state variables
  UserModel? get user => _user;
  List<UserModel> get users => _users;
  bool get isAcceptingWaste => _isAcceptingWaste;

  AdminProvider() {
    _firebaseApi.initNotifications();
  }

  // Fetch admin data from the backend
  Future<void> fetchAdminData() async {
    try {
      _user = await fetchUserData(Uri.parse(Constants.user));
      _isAcceptingWaste = await _binStateService.getAcceptingWasteStatus() ?? false;

      notifyListeners();
    } catch (e) {
      print('Error loading admin data: $e');
    }
  }

  // Fetch the list of users (assuming you have a service for this)
  Future<void> fetchUsers() async {
    try {
      // Implement user fetching logic here
      // _users = await _userService.fetchUsers();
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  // Toggle waste acceptance status and update backend
  Future<void> toggleWasteAcceptance() async {
    _isAcceptingWaste = !_isAcceptingWaste;
    print('Toggling Waste Acceptance: $_isAcceptingWaste');
    notifyListeners();

    String title = 'URecyCle';
    String body = _isAcceptingWaste
        ? 'Recycling Bin Ready: It\'s time to drop off your recyclables!'
        : 'Recycling Bin Closed: Please wait for the next cycle.';

    try {
      // Call the BinStateService to update the backend
      await _binStateService.toggleWasteAcceptance(_isAcceptingWaste);

      // Send notification to all users about the change in waste acceptance status
      await _firebaseApi.sendNotificationToAllUsers(
        title: title,
        body: body,
      );
      print("Notification sent to all users.");
    } catch (e) {
      print("Error toggling waste acceptance or sending notifications: $e");
    }
  }

  // Reset the admin state
  void reset() {
    _user = null;
    _users = [];
    _isAcceptingWaste = false;
    notifyListeners();
  }
}
