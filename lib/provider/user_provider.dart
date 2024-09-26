import 'package:flutter/material.dart';
import 'package:urecycle_app/model/user_model.dart';
import 'package:urecycle_app/model/leaderboard_model.dart';
import 'package:urecycle_app/services/firebase_service.dart';
import 'package:urecycle_app/services/leaderboard_service.dart';
import '../services/transaction_service.dart';
import '../services/disposal_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  LeaderboardEntry? _lbUser;
  List<Map<String, dynamic>> _top3Users = [];
  List<dynamic> _notifications = [];
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = false;

  // Add a variable to hold total disposals (optional)
  int _totalDisposals = 0;

  UserModel? get user => _user;
  LeaderboardEntry? get lbUser => _lbUser;
  List<Map<String, dynamic>> get top3Users => _top3Users;
  List<dynamic> get notifications => _notifications;
  List<Map<String, dynamic>> get transactions => _transactions;
  bool get isLoading => _isLoading;

  // Add getter for total disposals
  int get totalDisposals => _totalDisposals;

  final TransactionService _transactionService = TransactionService();
  final DisposalService _disposalService = DisposalService(); // Create an instance of DisposalService
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

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_user != null) {
        _transactions = await _transactionService.fetchTransactionsByStudentNumber(_user!.studentNumber);
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTotalDisposals() async {
    _isLoading = true;
    notifyListeners();

    try {
      _totalDisposals = await _disposalService.fetchTotalDisposals(); // Fetch the total disposals
    } catch (e) {
      print('Error fetching total disposals: $e');
    }

    _isLoading = false;
    notifyListeners();
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

  // Reset method to clear user data
  void reset() {
    _user = null;
    _lbUser = null;
    _top3Users = [];
    _notifications = [];
    _transactions = [];
    _totalDisposals = 0; // Reset total disposals
    _isLoading = false;
    notifyListeners();
  }
}
