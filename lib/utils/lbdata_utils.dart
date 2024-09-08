import 'package:urecycle_app/services/leaderboard_service.dart';
import 'package:urecycle_app/utils/userdata_utils.dart';
import 'package:urecycle_app/constants.dart';

Future<Map<String, dynamic>> loadUserData() async {
  final LeaderboardService lbService = LeaderboardService();
  final Uri url = Uri.parse(Constants.user);

  try {
    final user = await fetchUserData(url);
    final lbUser = await lbService.getEntryByStudentNumber(user?.studentNumber ?? '');
    final top3Users = await lbService.fetchTop3Entries();

    return {
      'user': user,
      'lbUser': lbUser,
      'top3Users': top3Users,
    };
  } catch (e) {
    print('Error loading user data: $e');
    throw e;
  }
}
