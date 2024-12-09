import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/hive_model/disposal_model_hive.dart';
import '../model/hive_model/leaderboard_model_hive.dart';
import '../model/hive_model/user_model_hive.dart';
import '../services/auth_service.dart';
import '../../services/firebase_service.dart';
import '../constants.dart';
import '../services/binstate_service.dart';
import '../services/disposal_service.dart';
import '../services/hive_service.dart';
import '../services/leaderboard_service.dart';
import '../services/user_service.dart';
import '../services/transaction_service.dart';

class AdminProvider with ChangeNotifier {
  // State variables
  Map<String, bool> _binStates = {
    'Plastic': false,
    'Paper': false,
    'Glass': false,
    'Metal': false,
    'Cardboard': false,
  };
  UserModel? _user;
  List<UserModel> _users = [];
  List<LeaderboardEntry> _leaderboards = [];
  List<LeaderboardEntry> _top3Users = [];
  List<Disposal> _weeklyDisposals = [];
  Map<String, double> _wasteTypePercentages = {};
  List<Map<String, dynamic>> _transactionsByWasteType = [];
  int _totalPointsByWasteType = 0;

  // Services
  final DisposalService _disposalService = DisposalService();
  final FirebaseApi _firebaseApi = FirebaseApi();
  final LeaderboardService _leaderboardService = LeaderboardService();
  final BinStateService _binStateService = BinStateService();
  final UserService _userService = UserService();
  final TransactionService _transactionService = TransactionService();

  // Hive boxes
  final _userBox = HiveService().userBox;
  final _leaderboardBox = HiveService().leaderboardBox;
  final _top3lbBox = HiveService().top3lbBox;
  final Box _binstateBox = HiveService().binBox;
  final Box _disposalBox = HiveService().disposalBox;

  // Getters
  Map<String, bool> get binStates => _binStates;
  UserModel? get user => _user;
  List<UserModel> get users => _users;
  List<LeaderboardEntry> get leaderboards => _leaderboards;
  List<LeaderboardEntry> get top3Users => _top3Users;
  List<Disposal> get weeklyDisposals => _weeklyDisposals;
  Map<String, double> get wasteTypePercentages => _wasteTypePercentages;
  Map<String, int> get wasteTypeTotals => _calculateWasteTypeTotals(_weeklyDisposals);
  List<Map<String, dynamic>> get transactionsByWasteType => _transactionsByWasteType;
  int get totalPointsByWasteType => _totalPointsByWasteType;

  AdminProvider() {
    _firebaseApi.initNotifications();
    fetchAdminData();
    fetchBinStates();
  }

  // Network connectivity checker
  Future<bool> _isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile);
  }

  // Fetch transactions by waste type
  Future<void> fetchTransactionsByWasteType(String wasteType) async {
    try {
      _transactionsByWasteType = await _transactionService.fetchTransactionsByWasteType(wasteType);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching transactions by waste type: $e');
    }
  }

  // Fetch total points by waste type
  Future<void> fetchTotalPointsByWasteType(String wasteType) async {
    try {
      _totalPointsByWasteType = await _transactionService.fetchTotalPointsByWasteType(wasteType);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching total points by waste type: $e');
    }
  }

  // Fetch admin data
  Future<void> fetchAdminData() async {
    try {
      _user = await fetchUserData(Uri.parse(Constants.user));
      final fetchedBinStates = await _binStateService.getAllBinStates();
      if (fetchedBinStates != null) {
        _binStates = fetchedBinStates;
      }
      if (_user != null) {
        await _userBox.put('user', _user!);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading admin data: $e');
    }
  }

  // Fetch all users
  Future<void> fetchUsers() async {
    try {
      _users = await _userService.fetchUsers();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching users: $e');
    }
  }

  // Fetch leaderboard entries
  Future<void> fetchLeaderboardEntries() async {
    if (await _isConnected()) {
      try {
        final leaderboardEntries = await _leaderboardService.fetchLeaderboardEntries();
        if (leaderboardEntries != null) {
          await _leaderboardBox.put('leaderboardEntries', leaderboardEntries);
          _leaderboards = leaderboardEntries;
          _top3Users = leaderboardEntries.take(3).toList();
        }
      } catch (e) {
        debugPrint('Error fetching leaderboard entries: $e');
      }
    } else {
      _leaderboards = _leaderboardBox.get('leaderboardEntries') ?? [];
      _top3Users = _top3lbBox.get('top3Users') ?? [];
    }
    notifyListeners();
  }

  // Fetch disposal data and calculate percentages
  Future<void> fetchDisposalData() async {
    try {
      _weeklyDisposals = await _disposalService.fetchWeeklyDisposals();
      Map<String, int> wasteTypeTotals = _calculateWasteTypeTotals(_weeklyDisposals);
      _wasteTypePercentages = _calculateWasteTypePercentages(wasteTypeTotals);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching disposal data: $e');
    }
  }

  // Calculate waste type totals
  Map<String, int> _calculateWasteTypeTotals(List<Disposal> disposals) {
    final totals = {'Cardboard': 0, 'Glass': 0, 'Metal': 0, 'Paper': 0, 'Plastic': 0};
    for (var disposal in disposals) {
      totals[disposal.wasteType] = (totals[disposal.wasteType] ?? 0) + 1;
    }
    return totals;
  }

  // Calculate waste type percentages
  Map<String, double> _calculateWasteTypePercentages(Map<String, int> totals) {
    final total = totals.values.fold(0, (a, b) => a + b);
    return total == 0
        ? totals.map((key, value) => MapEntry(key, 0.0))
        : totals.map((key, value) => MapEntry(key, (value / total) * 100));
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

  // Toggle a specific bin state
  Future<void> toggleBinState(String binType) async {
    try {
      final currentState = _binStates[binType] ?? false;
      final updatedState = !currentState;
      const title = 'URecyCle';
      final body = updatedState
          ? '$binType Bin Ready: It\'s time to drop off your recyclables!'
          : '$binType Bin Closed: Please wait for the next cycle.';

      await _binStateService.toggleBinState(binType, updatedState);
      await _firebaseApi.sendNotificationToAllUsers(title: title, body: body);

      _binStates[binType] = updatedState;
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling bin state for $binType: $e');
    }
  }

  // Reset state
  void reset() {
    _user = null;
    _users = [];
    _leaderboards = [];
    _top3Users = [];
    _weeklyDisposals = [];
    _wasteTypePercentages = {};
    _binStates = {
      'Plastic': false,
      'Paper': false,
      'Glass': false,
      'Metal': false,
      'Cardboard': false,
    };
    _transactionsByWasteType = [];
    _totalPointsByWasteType = 0;
    notifyListeners();
  }
}
