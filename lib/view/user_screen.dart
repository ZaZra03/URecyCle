import 'package:flutter/material.dart';
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/view/page/home_page.dart';
import 'package:urecycle_app/view/page/history_page.dart';
import 'package:urecycle_app/view/page/notification_page.dart';
import 'package:urecycle_app/view/page/profile_page.dart';
import 'package:urecycle_app/view/page/qr_page.dart';

import '../model/leaderboard_model.dart';
import '../model/user_model.dart';
import '../services/leaderboard_service.dart';
import '../utils/userdata_utils.dart';

class UserScreen extends StatefulWidget {
  final int initialPageIndex;

  const UserScreen({super.key, this.initialPageIndex = 0});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late PageController pageController;
  late int _selectedIndex;
  LeaderboardEntry? _lbUser;
  UserModel? _user;
  final LeaderboardService _lbService = LeaderboardService();
  final Uri _url = Uri.parse(Constants.user);
  late List<Map<String, dynamic>> _top3Users = [];

  final Map<int, String> _pageTitles = {
    0: 'Home',
    1: 'History',
    2: 'Scan',
    3: 'Notifications',
    4: 'Profile',
  };

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialPageIndex;
    pageController = PageController(initialPage: _selectedIndex);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await fetchUserData(_url);
      final lbUser = await _lbService.getEntryByStudentNumber(user?.studentNumber ?? '');
      final top3Users = await _lbService.fetchTop3Entries();
      print(lbUser?.name);
      print(lbUser?.studentNumber);

      setState(() {
        _user = user;
        _lbUser = lbUser;
        _top3Users = top3Users;
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex] ?? 'App Title',
          style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Constants.primaryColor,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Home(lbUser: _lbUser, user: _user, top3Users: _top3Users,),
          const History(),
          const BarcodeScannerWithOverlay(),
          const Notifications(),
          Profile(user: _user),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedIndex = 2;
            pageController.jumpToPage(2);
          });
        },
        backgroundColor: Constants.primary02Color,
        foregroundColor: _selectedIndex == 2
            ? Colors.white
            : Constants.gray04Color,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Constants.primaryColor,
        notchMargin: 10.0,
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home_outlined),
              color: _selectedIndex == 0 ? Colors.white : Constants.gray04Color,
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                  pageController.jumpToPage(0);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.history),
              color: _selectedIndex == 1 ? Colors.white : Constants.gray04Color,
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                  pageController.jumpToPage(1);
                });
              },
            ),
            const SizedBox(width: 40), // Spacer for FAB
            IconButton(
              icon: const Icon(Icons.notifications),
              color: _selectedIndex == 3 ? Colors.white : Constants.gray04Color,
              onPressed: () {
                setState(() {
                  _selectedIndex = 3;
                  pageController.jumpToPage(3);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              color: _selectedIndex == 4 ? Colors.white : Constants.gray04Color,
              onPressed: () {
                setState(() {
                  _selectedIndex = 4;
                  pageController.jumpToPage(4);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
