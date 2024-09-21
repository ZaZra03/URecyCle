import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 3,
            child: Image.asset(
              "assets/icon/logo.png",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          // Wrapping the LinearProgressIndicator in a Container with a specific width
          const SizedBox(
            width: 200, // Set a specific width
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}