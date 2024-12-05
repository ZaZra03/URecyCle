import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:urecycle_app/services/firebase_service.dart';
import 'package:urecycle_app/services/leaderboard_service.dart';
import '../model/hive_model/leaderboard_model_hive.dart';
import '../model/hive_model/transaction_model_hive.dart';
import '../model/hive_model/user_model_hive.dart';
import '../services/binstate_service.dart';
import '../services/hive_service.dart';
import '../services/transaction_service.dart';
import '../services/disposal_service.dart';

class UserProvider with ChangeNotifier {
  Map<String, bool> _binStates = {
    'Plastic': false,
    'Paper': false,
    'Glass': false,
    'Metal': false,
    'Cardboard': false,
  };
  UserModel? _user;
  LeaderboardEntry? _lbUser;
  List<LeaderboardEntry> _leaderboards = [];
  List<LeaderboardEntry> _top3Users = [];
  List<dynamic> _notifications = [];
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  int _totalDisposals = 0;

  // Getters
  Map<String, bool> get binStates => _binStates;
  UserModel? get user => _user;
  LeaderboardEntry? get lbUser => _lbUser;
  List<LeaderboardEntry> get leaderboards => _leaderboards;
  List<LeaderboardEntry> get top3Users => _top3Users;
  List<dynamic> get notifications => _notifications;
  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  int get totalDisposals => _totalDisposals;

  // Services
  final TransactionService _transactionService = TransactionService();
  final LeaderboardService _leaderboardService = LeaderboardService();
  final DisposalService _disposalService = DisposalService();
  final BinStateService _binStateService = BinStateService();
  final FirebaseApi _firebaseApi = FirebaseApi();

  // Hive boxes
  final _userBox = HiveService().userBox;
  final _userlbBox = HiveService().userlbBox;
  final _leaderboardBox = HiveService().leaderboardBox;
  final _top3lbBox = HiveService().top3lbBox;
  final _notificationsBox = HiveService().notificationsBox;
  final _transactionsBox = HiveService().transactionsBox;
  final _totaldisposalBox = HiveService().totaldisposalBox;

  // Initialize Firebase notifications
  Future<void> initNotifications() async {
    await _firebaseApi.initNotifications();
  }

  // Check network connection
  Future<bool> _isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile);
  }


  // Fetch user data from the service and store it in Hive
  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();

    if (await _isConnected()) {
      try {
        final data = await _leaderboardService.loadUserData();
        _user = UserModel.fromJson(data['user']);
        _lbUser = LeaderboardEntry.fromJson(data['lbUser']);
        _top3Users = (data['top3Users'] as List<dynamic>)
            .map((user) => LeaderboardEntry.fromJson(user))
            .toList();

        // Store data in Hive
        await _userBox.put('user', _user!);
        await _userlbBox.put('lbUser', _lbUser!);
        await _top3lbBox.put('top3Users', _top3Users);
      } catch (e) {
        print('Error loading user data: $e');
      }
    } else {
      // Load specific data from Hive when offline
      _user = _userBox.get('user');
      _lbUser = _userlbBox.get('lbUser');
      _top3Users = _top3lbBox.get('top3Users')!;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch all leaderboard entries and store in Hive
  Future<void> fetchLeaderboardEntries() async {
    _isLoading = true;
    notifyListeners();

    if (await _isConnected()) {
      try {
        final leaderboardEntries = await _leaderboardService.fetchLeaderboardEntries();
        if (leaderboardEntries != null) {
          // Save leaderboard entries in the Hive box
          await _leaderboardBox.put('leaderboardEntries', leaderboardEntries);

          // Update provider data
          _leaderboards = leaderboardEntries;
          _top3Users = leaderboardEntries.take(3).toList();
        }
      } catch (e) {
        print('Error fetching leaderboard entries: $e');
      }
    } else {
      _leaderboards = _leaderboardBox.get('leaderboardEntries')!;
      _top3Users = _top3lbBox.get('top3Users')!;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch notifications and store in Hive
  Future<void> fetchNotifications() async {
    if (await _isConnected()) {
      try {
        _notifications = await _firebaseApi.fetchNotifications(_user!.studentNumber);

        // Store notifications in Hive
        await _notificationsBox.put('notifications', _notifications);
      } catch (e) {
        print('Error fetching notifications: $e');
      }
    } else {
      // Load notifications from Hive when offline
      _notifications = _notificationsBox.get('notifications')!;
    }
    notifyListeners();
  }

  // Fetch transactions and store in Hive
  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    if (await _isConnected()) {
      try {
        if (_user != null) {
          _transactions = (await _transactionService.fetchTransactionsByStudentNumber(_user!.studentNumber))
              .map((transaction) => TransactionModel.fromJson(transaction))
              .toList();

          // Store transactions in Hive
          await _transactionsBox.put('transactions', _transactions);
        }
      } catch (e) {
        print('Error fetching transactions: $e');
      }
    } else {
      // Load transactions from Hive when offline
      _transactions = _transactionsBox.get('transactions')!;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch bin states from the backend
  Future<void> fetchBinStates() async {
    try {
      final fetchedBinStates = await _binStateService.getAllBinStates();
      if (fetchedBinStates != null) {
        _binStates = fetchedBinStates;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching bin states: $e');
    }
  }

  // Fetch total disposals and store in Hive
  Future<void> fetchTotalDisposals() async {
    _isLoading = true;
    notifyListeners();

    if (await _isConnected()) {
      try {
        _totalDisposals = await _disposalService.fetchTotalDisposals();

        // Store total disposals in Hive
        await _totaldisposalBox.put('totalDisposals', _totalDisposals);
      } catch (e) {
        print('Error fetching total disposals: $e');
      }
    } else {
      // Load total disposals from Hive when offline
      _totalDisposals = _totaldisposalBox.get('totalDisposals')!;
    }

    _isLoading = false;
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

  // Reset all data in provider and clear Hive storage
  void reset() {
    _userBox.clear();
    _userlbBox.clear();
    _leaderboardBox.clear();
    _top3lbBox.clear();
    _notificationsBox.clear();
    _transactionsBox.clear();
    _totaldisposalBox.clear();
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
