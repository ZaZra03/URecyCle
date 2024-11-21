import 'package:flutter/material.dart';

import '../../../constants.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(
            color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Welcome to our app! Our goal is to simplify your tasks while ensuring you enjoy a seamless and user-friendly experience. '
                      'We are committed to delivering innovative solutions tailored to your needs.\n\n'
                      'For any inquiries or support, please contact us at:\n\n'
                      '📧 Email: support@yourapp.com\n'
                      '📞 Phone: +123-456-7890\n',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}