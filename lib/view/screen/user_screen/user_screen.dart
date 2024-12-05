import 'package:flutter/material.dart';
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/view/page/home_page.dart';
import 'package:urecycle_app/view/page/transaction_page.dart';
import 'package:urecycle_app/view/page/notification_page.dart';
import 'package:urecycle_app/view/page/profile_page.dart';
import 'package:urecycle_app/view/page/qr_page.dart';
import 'package:urecycle_app/view/screen/user_screen/recycleditems_screen.dart';
import 'package:urecycle_app/view/screen/user_screen/reward_screen.dart';
import '../../../services/binstate_service.dart';
import 'onboarding_screen.dart';

class UserScreen extends StatefulWidget {
  final int initialPageIndex;
  final String role;

  const UserScreen({
    super.key,
    this.initialPageIndex = 0,
    required this.role,
  });

  @override
  State<UserScreen> createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  late PageController pageController;
  late int _selectedIndex;
  bool _isBinStatesLoaded = false;
  Map<String, bool> _binStates = {};

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
  }

  Future<void> _loadBinStates() async {
    try {
      print("Fetching bin states...");
      BinStateService binStateService = BinStateService();
      final binStates = await binStateService.getAllBinStates();
      print("Bin states fetched: $binStates");
      if (binStates != null) {
        setState(() {
          _binStates = binStates;
          _isBinStatesLoaded = true;
        });
      } else {
        print("Bin states are null.");
        setState(() {
          _isBinStatesLoaded = false;
        });
      }
    } catch (e) {
      print("Error loading bin states: $e");
      setState(() {
        _isBinStatesLoaded = false;
      });
    }
  }

  void _showBinStatesDialog() async {
    // Call _loadBinStates only when the info icon is pressed
    await _loadBinStates();

    // Prepare the list of bin status messages based on the current bin states
    List<Widget> binStateWidgets = [];

    _binStates.forEach((binType, isOpen) {
      String statusMessage = '$binType Bin ${isOpen ? 'Open' : 'Closed'}';
      binStateWidgets.add(
        ListTile(
          title: Text(statusMessage),
          trailing: Icon(
            isOpen ? Icons.check_circle : Icons.cancel_outlined,
            color: isOpen ? Colors.green : Colors.red,
          ),
        ),
      );
    });

    // Check if the widget is still mounted before calling showDialog
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Bin States'),
            content: _isBinStatesLoaded
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: binStateWidgets,
            )
                : const Center(child: CircularProgressIndicator()),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  bool _areAllBinsClosed() {
    // Return true if all bin states are false (closed), or if the states are not yet loaded
    return _isBinStatesLoaded && _binStates.values.every((isOpen) => !isOpen);
  }

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
        actions: _selectedIndex == 0
            ? [
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RewardScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline), // Help icon
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnboardingScreen(),
                ),
              );
            },
          ),
        ]
            : _selectedIndex == 2
            ? [
          IconButton(
            icon: const Icon(Icons.info_outline), // Info icon
            color: Colors.white,
            onPressed: _showBinStatesDialog,
          ),
          IconButton(
            icon: const Icon(Icons.help_outline), // Help icon
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecyclingItemsScreen(),
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

          if (index == 2 && !_isBinStatesLoaded) {
            _loadBinStates(); // Load bin states when navigating to Scan
          }
        },
        children: [
          const Home(),
          const Transaction(),
          _isBinStatesLoaded
              ? (_areAllBinsClosed()
              ? const SafeArea(
            child: Center(
              child: Text(
                'Recycling Bin Closed',
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
              : QRScanner(role: 'student', binStates: _binStates,))
              : const Center(child: CircularProgressIndicator()), // Show loader until states are loaded
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
        foregroundColor: _selectedIndex == 2 ? Colors.white : Constants.gray04Color,
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
            const SizedBox(width: 40),
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