import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/hive_model/disposal_model_hive.dart';
import '../model/hive_model/user_model_hive.dart';
import '../services/auth_service.dart';
import '../../services/firebase_service.dart';
import '../constants.dart';
import '../services/binstate_service.dart';
import '../services/disposal_service.dart';
import '../services/hive_service.dart';
import '../services/user_service.dart';

class AdminProvider with ChangeNotifier {
  bool _isAcceptingWaste = false;
  UserModel? _user;
  List<UserModel> _users = [];
  List<Disposal> _weeklyDisposals = [];
  Map<String, double> _wasteTypePercentages = {};

  // Services
  final DisposalService _disposalService = DisposalService();
  final FirebaseApi _firebaseApi = FirebaseApi();
  final BinStateService _binStateService = BinStateService();
  final UserService _userService = UserService();

  // Hive boxes
  final _userBox = HiveService().userBox;
  final Box _binstateBox = HiveService().binBox;
  final Box _disposalBox = HiveService().disposalBox;

  // Getters for accessing state variables
  UserModel? get user => _user;
  List<UserModel> get users => _users;
  bool get isAcceptingWaste => _isAcceptingWaste;
  List<Disposal> get weeklyDisposals => _weeklyDisposals;
  Map<String, double> get wasteTypePercentages => _wasteTypePercentages;

  AdminProvider() {
    _firebaseApi.initNotifications();
    fetchAdminData(); // Automatically fetch admin data on initialization
  }

  // Fetch admin data from the backend
  Future<void> fetchAdminData() async {
    try {
      _user = await fetchUserData(Uri.parse(Constants.user));
      _isAcceptingWaste = await _binStateService.getAcceptingWasteStatus() ?? false;

      await _userBox.put('user', _user!);

      notifyListeners();
    } catch (e) {
      print('Error loading admin data: $e');
      // Optionally, handle error state for UI
    }
  }

  // Fetch the list of users
  Future<void> fetchUsers() async {
    try {
      _users = await _userService.fetchUsers();
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
      // Optionally, handle error state for UI
    }
  }

  // Fetch disposal data and calculate waste percentages
  Future<void> fetchDisposalData() async {
    try {
      print("fetchDisposalData is called");
      _weeklyDisposals = (await _disposalService.fetchAllDisposals()).toList();

      // Log fetched disposals for debugging
      print("Filtered Weekly Disposals: $_weeklyDisposals");

      // Calculate percentage of waste types
      Map<String, int> wasteTypeTotals = _calculateWasteTypeTotals(_weeklyDisposals);
      _wasteTypePercentages = _calculateWasteTypePercentages(wasteTypeTotals);

      print("Waste Type Percentages: $_wasteTypePercentages");

      notifyListeners();
    } catch (e) {
      print('Error fetching disposal data: $e');
      // Optionally, handle error state for UI
    }
  }

  // Calculate totals for each waste type
  Map<String, int> _calculateWasteTypeTotals(List<Disposal> disposals) {
    Map<String, int> wasteTypeTotals = {
      'Cardboard': 0,
      'Glass': 0,
      'Metal': 0,
      'Paper': 0,
      'Plastic': 0,
    };

    for (var disposal in disposals) {
      print('Processing Disposal: ${disposal.wasteType}');
      wasteTypeTotals[disposal.wasteType] = (wasteTypeTotals[disposal.wasteType] ?? 0) + 1;
    }

    print('Waste Type Totals: $wasteTypeTotals');
    return wasteTypeTotals;
  }

  // Calculate percentages of each waste type
  Map<String, double> _calculateWasteTypePercentages(Map<String, int> totals) {
    int totalDisposals = totals.values.fold(0, (a, b) => a + b);
    if (totalDisposals == 0) {
      return totals.map((key, value) => MapEntry(key, 0.0)); // Avoid division by zero
    }
    return totals.map((key, value) => MapEntry(key, (value / totalDisposals) * 100));
  }

  // Toggle waste acceptance status and update backend
  Future<void> toggleWasteAcceptance() async {
    bool updatedStatus = !_isAcceptingWaste;
    print('Toggling Waste Acceptance: $updatedStatus');

    String title = 'URecyCle';
    String body = updatedStatus
        ? 'Recycling Bin Ready: It\'s time to drop off your recyclables!'
        : 'Recycling Bin Closed: Please wait for the next cycle.';

    try {
      await _binStateService.toggleWasteAcceptance(updatedStatus);
      _isAcceptingWaste = updatedStatus;
      await _firebaseApi.sendNotificationToAllUsers(title: title, body: body);
      print("Notification sent to all users.");
      notifyListeners(); // Notify after successful toggle and notification
    } catch (e) {
      print("Error toggling waste acceptance or sending notifications: $e");
      // Optionally, handle error state for UI
    }
  }

  // Reset the admin state
  void reset() {
    _user = null;
    _users = [];
    _weeklyDisposals = [];
    _wasteTypePercentages = {};
    _isAcceptingWaste = false;
    notifyListeners();
  }
}
