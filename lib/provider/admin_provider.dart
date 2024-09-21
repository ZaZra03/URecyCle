import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import 'package:urecycle_app/services/auth_service.dart';
import '../constants.dart';
import '../model/user_model.dart';
// import 'package:urecycle_app/utils/userdata_utils.dart';

class AdminProvider with ChangeNotifier {
  bool isAcceptingWaste = false;
  UserModel? _user;
  final Uri url = Uri.parse(Constants.user);
  final FirebaseApi _firebaseApi = FirebaseApi();

  UserModel? get user => _user;

  AdminProvider() {
    _firebaseApi.initNotifications();
  }

  Future<void> fetchAdminData() async {
    try {
      _user = await fetchUserData(url);
    } catch (e) {
      print('Error loading admin data: $e');
    }
  }

  void toggleWasteAcceptance() async {
    isAcceptingWaste = !isAcceptingWaste;
    notifyListeners();  // Notify listeners when the state changes

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

}
