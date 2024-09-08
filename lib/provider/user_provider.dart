import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../model/leaderboard_model.dart';
import '../../utils/lbdata_utils.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  LeaderboardEntry? _lbUser;
  List<Map<String, dynamic>> _top3Users = [];

  UserModel? get user => _user;
  LeaderboardEntry? get lbUser => _lbUser;
  List<Map<String, dynamic>> get top3Users => _top3Users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
}
