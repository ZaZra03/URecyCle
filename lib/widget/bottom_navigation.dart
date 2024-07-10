import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      foregroundColor: currentIndex == 4
                          ? Colors.black // Highlighted color
                          : Colors.white, // Default color
                      elevation: 0.1,
                      tooltip: 'Scan',
                      onPressed: () {
                        setBottomBarIndex(4); // Set index for FAB
                      },
                      shape: const CircleBorder(),
                      child: const Icon(Icons.document_scanner_outlined),
                    ),
                  ),
                  SizedBox(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            color:
                            currentIndex == 0 ? Colors.black : Colors.white,
                          ),
                          tooltip: 'Home',
                          onPressed: () {
                            setBottomBarIndex(0);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.history,
                            color:
                            currentIndex == 1 ? Colors.black : Colors.white,
                          ),
                          tooltip: 'History',
                          onPressed: () {
                            setBottomBarIndex(1);
                          },
                        ),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.notifications,
                            color:
                            currentIndex == 2 ? Colors.black : Colors.white,
                          ),
                          tooltip: 'Notification',
                          onPressed: () {
                            setBottomBarIndex(2);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.person,
                            color:
                            currentIndex == 3 ? Colors.black : Colors.white,
                          ),
                          tooltip: 'Profile',
                          onPressed: () {
                            setBottomBarIndex(3);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF5DB075)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}