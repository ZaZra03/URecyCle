import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:urecycle_app/model/hive_model/binstate_model_hive.dart';
import 'package:urecycle_app/model/hive_model/leaderboard_model_hive.dart';
import 'package:urecycle_app/model/hive_model/reward_model_hive.dart';
import 'package:urecycle_app/model/hive_model/pushnotification_model_hive.dart';
import 'package:urecycle_app/model/hive_model/transaction_model_hive.dart';
import 'package:urecycle_app/model/hive_model/user_model_hive.dart';
import 'package:urecycle_app/model/hive_model/disposal_model_hive.dart';
import 'package:urecycle_app/model/hive_model/usernotification_model_hive.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() {
    return _instance;
  }

  HiveService._internal();

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    registerAdapters();

    // Open the boxes
    await Future.wait([
      Hive.openBox<BinStateModel>('binBox'),
      Hive.openBox<Disposal>('disposalBox'),
      Hive.openBox<int>('totaldisposalBox'),
      Hive.openBox<LeaderboardEntry>('userlbBox'),
      Hive.openBox<List<LeaderboardEntry>>('leaderboardBox'),
      Hive.openBox<List<LeaderboardEntry>>('top3lbBox'),
      Hive.openBox<List<dynamic>>('notificationBox'), // Consider specifying a type if possible
      Hive.openBox<RewardModel>('rewardBox'),
      Hive.openBox<List<TransactionModel>>('transactionBox'),
      Hive.openBox<UserModel>('userBox'),
      Hive.openBox<UserNotificationModel>('usernotificationBox'),
    ]);
  }

  void registerAdapters() {
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(BinStateModelAdapter());
    Hive.registerAdapter(DisposalAdapter());
    Hive.registerAdapter(LeaderboardEntryAdapter());
    Hive.registerAdapter(NotificationModelAdapter());
    Hive.registerAdapter(RewardModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    // Add more adapters as needed
  }

  Box<UserModel> get userBox => Hive.box<UserModel>('userBox');
  Box<LeaderboardEntry> get userlbBox => Hive.box<LeaderboardEntry>('userlbBox');
  Box<List<dynamic>> get notificationsBox => Hive.box<List<dynamic>>('notificationBox');
  Box<List<TransactionModel>> get transactionsBox => Hive.box<List<TransactionModel>>('transactionBox');
  Box<Disposal> get disposalBox => Hive.box<Disposal>('disposalBox');
  Box<int> get totaldisposalBox => Hive.box<int>('totaldisposalBox');
  Box<BinStateModel> get binBox => Hive.box<BinStateModel>('binBox');
  Box<List<LeaderboardEntry>> get leaderboardBox => Hive.box<List<LeaderboardEntry>>('leaderboardBox');
  Box<List<LeaderboardEntry>> get top3lbBox => Hive.box<List<LeaderboardEntry>>('top3lbBox');
  Box<RewardModel> get rewardBox => Hive.box<RewardModel>('rewardBox');

}
