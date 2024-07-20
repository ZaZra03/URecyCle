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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Center(
              child: Home(),
            ),
            Center(
              child: History(),
            ),
            Center(
              child: Scan(),
            ),
            Center(
              child: Notifications(),
            ),
            Center(
              child: Profile(),
            ),
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
        backgroundColor: Constants.secondaryColor,
        foregroundColor: _selectedIndex == 2
            ? Colors.white // Highlighted color
            : Colors.black, // Default color
        shape: CircleBorder(),
        child: Icon(Icons.document_scanner_outlined),
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
              icon: Icon(Icons.home_outlined),
              color: _selectedIndex == 0 ? Colors.white : Colors.black,
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                  pageController.jumpToPage(0);
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.history),
              color: _selectedIndex == 1 ? Colors.white : Colors.black,
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                  pageController.jumpToPage(1);
                });
              },
            ),
            SizedBox(width: 40), // Spacer for FAB
            IconButton(
              icon: Icon(Icons.notifications),
              color: _selectedIndex == 3 ? Colors.white : Colors.black,
              onPressed: () {
                setState(() {
                  _selectedIndex = 3;
                  pageController.jumpToPage(3);
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle_outlined),
              color: _selectedIndex == 4 ? Colors.white : Colors.black,
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
  const Scan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Scan');
  }
}
