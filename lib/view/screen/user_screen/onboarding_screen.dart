import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:urecycle_app/view/screen/user_screen/user_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (currentPageIndex != onboardingPages.length - 1)
            TextButton(
              onPressed: () {
                _pageController.animateToPage(
                  onboardingPages.length - 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.blue),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            children: onboardingPages,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,  // Makes the column take only as much space as necessary
              children: [
                if (currentPageIndex == onboardingPages.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserScreen(role: 'student')),
                        );
                      },
                      child: const Text('Get Started'),
                    ),
                  ),
                const SizedBox(height: 45),  // Space between button and page indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: onboardingPages.length,
                    effect: WormEffect(
                      dotHeight: 6,
                      dotWidth: 12,
                      spacing: 16,
                      activeDotColor: Theme.of(context).primaryColor,
                      dotColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<Widget> onboardingPages = const [
    OnboardingPage(
      title: 'Welcome',
      description: 'Learn how to recycle waste effectively and sustainably.',
      image: 'assets/images/recycle.gif',
    ),
    OnboardingPage(
      title: 'Scan QR Code',
      description: 'Tap the button at the bottom to scan QR codes near the bins.',
      image: 'assets/images/onboarding2.png',
    ),
    OnboardingPage(
      title: 'Locate Recycling Bins',
      description: 'Find QR codes near bins inside the university for disposal.',
      image: 'assets/images/qr.gif',
    ),
    OnboardingPage(
      title: 'Classify Waste',
      description:
      'Snap a photo and let the app determine if your waste is recyclable.',
      image: 'assets/images/classify.gif',
    ),
    OnboardingPage(
      title: 'Leaderboard',
      description:
      'Earn points by recycling and compare your progress with others.',
      image: 'assets/images/leaderboard.gif',
    ),
    OnboardingPage(
      title: 'Rewards',
      description:
      'Redeem exciting rewards for your efforts in making a greener planet!',
      image: 'assets/images/reward.gif',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300),
          const SizedBox(height: 32),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium, // For large headings
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium, // For body text
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
