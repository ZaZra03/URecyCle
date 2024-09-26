import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/view/page/home_page.dart';
import 'package:urecycle_app/view/page/transaction_page.dart';
import 'package:urecycle_app/view/page/notification_page.dart';
import 'package:urecycle_app/view/page/profile_page.dart';
import 'package:urecycle_app/view/page/qr_page.dart';
import 'package:urecycle_app/view/screen/reward_screen.dart'; // Import your reward page

import '../../provider/admin_provider.dart';

class UserScreen extends StatefulWidget {
  final int initialPageIndex;
  final String role;

  const UserScreen({super.key, this.initialPageIndex = 0, required this.role});

  @override
  State<UserScreen> createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  late PageController pageController;
  late int _selectedIndex;

  final Map<int, String> pageTitles = {
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
  }

  // Setter for selected index
  void setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(
              pageTitles[_selectedIndex] ?? 'App Title',
              style: const TextStyle(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Constants.primaryColor,
            actions: _selectedIndex == 0 // Display reward icon only on the Home page
                ? [
              IconButton(
                icon: const Icon(Icons.card_giftcard),
                color: Colors.white,// Reward icon
                onPressed: () {
                  // Navigate to the reward page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RewardScreen(),
                    ),
                  );
                },
              ),
            ]
                : [],
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              const Home(),
              const Transaction(),
              adminProvider.isAcceptingWaste
                  ? const BarcodeScannerWithOverlay()
                  : const SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Recycling Bin Closed',
                          style: TextStyle(fontSize: 18,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Notifications(),
              const Profile(role: 'student'),
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
      },
    );
  }
}
