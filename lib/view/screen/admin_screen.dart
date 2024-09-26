import 'package:flutter/material.dart';
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/view/page/dashboard_page.dart';
import 'package:urecycle_app/view/page/profile_page.dart';
import 'package:urecycle_app/view/page/scan_page.dart';

class AdminScreen extends StatefulWidget {
  final String role;

  const AdminScreen({super.key, required this.role});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  // Define a map for page titles
  final Map<int, String> _pageTitles = {
    0: 'Dashboard',
    1: 'Scan',
    2: 'Profile',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex] ?? 'App Title', // Default title if index not found
          style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Constants.primaryColor,
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.more_vert),
        //     color: Colors.white,
        //     onPressed: () {
        //       // Handle settings action
        //     },
        //   ),
        // ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const <Widget>[
          Dashboard(),
          Scan(),
          Profile(role: 'admin',),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedIndex = 1;
            _pageController.jumpToPage(1);
          });
        },
        backgroundColor: Constants.primary02Color,
        foregroundColor: _selectedIndex == 1 ? Colors.white : Constants.gray04Color,
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
              icon: const Icon(Icons.dashboard),
              color: _selectedIndex == 0 ? Colors.white : Constants.gray04Color,
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                  _pageController.jumpToPage(0);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              color: _selectedIndex == 2 ? Colors.white : Constants.gray04Color,
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                  _pageController.jumpToPage(2);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}