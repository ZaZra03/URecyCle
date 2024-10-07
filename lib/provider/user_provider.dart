import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  int _totalDisposals = 0;

  UserModel? get user => _user;
  LeaderboardEntry? get lbUser => _lbUser;
  List<Map<String, dynamic>> get top3Users => _top3Users;
  List<dynamic> get notifications => _notifications;
  List<Map<String, dynamic>> get transactions => _transactions;
  bool get isLoading => _isLoading;

  int get totalDisposals => _totalDisposals;

  final TransactionService _transactionService = TransactionService();
  final LeaderboardService _leaderboardService = LeaderboardService();
  final DisposalService _disposalService = DisposalService();
  final FirebaseApi _firebaseApi = FirebaseApi();

  // Initialize Hive boxes
  final Box _userBox = Hive.box('userBox');
  final Box _notificationsBox = Hive.box('notificationsBox');
  final Box _transactionsBox = Hive.box('transactionsBox');
  final Box _disposalBox = Hive.box('disposalBox');


  // Initialize Firebase notifications
  Future<void> initNotifications() async {
    await _firebaseApi.initNotifications();
  }

  // Fetch user data from the service and store it in Hive
  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _leaderboardService.loadUserData();
      _user = data['user'];
      _lbUser = data['lbUser'];
      _top3Users = List<Map<String, dynamic>>.from(data['top3Users']);

      // Store user data in Hive
      await _userBox.put('user', _user?.toJson());
      await _userBox.put('lbUser', _lbUser?.toJson());
      await _userBox.put('top3Users', _top3Users);
    } catch (e) {
      print('Error loading user data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch notifications and store in Hive
  Future<void> fetchNotifications() async {
    try {
      _notifications = await _firebaseApi.fetchNotifications(_user!.studentNumber);

      // Store notifications in Hive
      await _notificationsBox.put('notifications', _notifications);

      notifyListeners();
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  // Fetch transactions and store in Hive
  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_user != null) {
        _transactions = await _transactionService.fetchTransactionsByStudentNumber(_user!.studentNumber);

        // Store transactions in Hive
        await _transactionsBox.put('transactions', _transactions);
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch total disposals and store in Hive
  Future<void> fetchTotalDisposals() async {
    _isLoading = true;
    notifyListeners();

    try {
      _totalDisposals = await _disposalService.fetchTotalDisposals();

      // Store total disposals in Hive
      await _disposalBox.put('totalDisposals', _totalDisposals);
    } catch (e) {
      print('Error fetching total disposals: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Load total disposals from Hive
  void loadDisposalsFromHive() {
    _totalDisposals = _disposalBox.get('totalDisposals', defaultValue: 0);
    notifyListeners();
  }

  // Delete notification and update Hive
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firebaseApi.deleteNotification(_user!.studentNumber, notificationId);
      _notifications.removeWhere((notification) => notification['_id'] == notificationId);

      // Update notifications in Hive
      await _notificationsBox.put('notifications', _notifications);

      notifyListeners();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // Load data from Hive into provider variables
  void loadFromHive() {
    _user = UserModel.fromJson(_userBox.get('user'));
    _lbUser = LeaderboardEntry.fromJson(_userBox.get('lbUser'));
    _top3Users = List<Map<String, dynamic>>.from(_userBox.get('top3Users', defaultValue: []));
    _notifications = _notificationsBox.get('notifications', defaultValue: []);
    _transactions = _transactionsBox.get('transactions', defaultValue: []);
    _totalDisposals = _userBox.get('totalDisposals', defaultValue: 0);
    notifyListeners();
  }

  // Reset all data in provider and clear Hive storage
  void reset() {
    _userBox.clear();
    _notificationsBox.clear();
    _transactionsBox.clear();
    _user = null;
    _lbUser = null;
    _top3Users = [];
    _notifications = [];
    _transactions = [];
    _totalDisposals = 0;
    _isLoading = false;
    notifyListeners();
  }
}
