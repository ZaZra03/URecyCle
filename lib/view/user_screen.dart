import 'package:flutter/material.dart';
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/view/page/home_page.dart';
import 'package:urecycle_app/view/page/history_page.dart';
import 'package:urecycle_app/view/page/notification_page.dart';
import 'package:urecycle_app/view/page/profile_page.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  final PageController pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  final Map<int, String> _pageTitles = {
    0: 'Home',
    1: 'History',
    2: 'Scan',
    3: 'Notifications',
    4: 'Profile',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex] ?? 'App Title', // Default title if index not found
          style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Constants.primaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: Colors.white,
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: const <Widget>[
            Home(),
            History(),
            Scan(),
            Notifications(),
            Profile(),
          ],
        ),
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
            : Constants.gray04Color, // Default color
        shape: const CircleBorder(),
        child: const Icon(Icons.document_scanner_outlined),
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

class Scan extends StatelessWidget {
  const Scan({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Scan');
  }
}
