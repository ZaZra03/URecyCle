import 'package:flutter/material.dart';
import '../../../constants.dart';

class MissionVisionScreen extends StatefulWidget {
  const MissionVisionScreen({super.key});

  @override
  State createState() => _MissionVisionScreen();
}

class _MissionVisionScreen extends State<MissionVisionScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mission & Vision',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(
            color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: _onPageChanged,
              children: [
                _buildPage(
                  title: 'MISSION',
                  content:
                      'As an institution of higher learning, UC (PnC) is committed to '
                      'equip individuals with knowledge, skills, and values that will enable '
                      'them to achieve their professional goals & provide leadership and '
                      'service for national development.',
                ),
                _buildPage(
                  title: 'VISION',
                  content:
                      'A premier institution of higher learning in Region IV, '
                      'developing globally-competitive and value-laden professionals '
                      'and leaders instrumental to community development and nation-building',
                ),
              ],
            ),
          ),
          // Custom Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPage({required String title, required String content}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
