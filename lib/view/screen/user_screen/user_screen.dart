import 'package:flutter/material.dart';
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/view/page/home_page.dart';
import 'package:urecycle_app/view/page/transaction_page.dart';
import 'package:urecycle_app/view/page/notification_page.dart';
import 'package:urecycle_app/view/page/profile_page.dart';
import 'package:urecycle_app/view/page/qr_page.dart';
import 'package:urecycle_app/view/screen/user_screen/reward_screen.dart';
import '../../../services/binstate_service.dart';

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
  bool _isAcceptingWaste = false;

  final Map<int, String> pageTitles = {
    0: 'Home',
    1: 'Transactions',
    2: 'Scan',
    3: 'Notifications',
    4: 'Profile',
  };

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialPageIndex;
    pageController = PageController(initialPage: _selectedIndex);
    _fetchBinState();
  }

  Future<void> _fetchBinState() async {
    try {
      BinStateService binStateService = BinStateService();
      bool? isAcceptingWaste = await binStateService.getAcceptingWasteStatus();
      if (isAcceptingWaste != null) {
        setState(() {
          _isAcceptingWaste = isAcceptingWaste;
        });
      }
    } catch (e) {
      print('Error fetching bin state: $e');
    }
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
            color: Colors.white, // Reward icon
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
          _isAcceptingWaste
              ? const QRScanner(role: 'student')
              : const SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Recycling Bin Closed',
                      style: TextStyle(fontSize: 18),
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
          _fetchBinState();
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
                setSelectedIndex(0);
              },
            ),
            IconButton(
              icon: const Icon(Icons.history),
              color: _selectedIndex == 1 ? Colors.white : Constants.gray04Color,
              onPressed: () {
                setSelectedIndex(1);
              },
            ),
            const SizedBox(width: 40), // Spacer for FAB
            IconButton(
              icon: const Icon(Icons.notifications),
              color: _selectedIndex == 3 ? Colors.white : Constants.gray04Color,
              onPressed: () {
                setSelectedIndex(3);
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              color: _selectedIndex == 4 ? Colors.white : Constants.gray04Color,
              onPressed: () {
                setSelectedIndex(4);
              },
            ),
          ],
        ),
      ),
    );
  }
}
