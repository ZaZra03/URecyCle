import 'package:flutter/material.dart';
import '../../../constants.dart';

class FAQ extends StatelessWidget {
  const FAQ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAQ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(
            color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: ListView(
          children: [
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildFAQItem(
              context,
              'What is this app about?',
              'This app helps you manage tasks efficiently and provides personalized features tailored to your needs.',
            ),
            _buildFAQItem(
              context,
              'How do I update my profile?',
              'Go to the "Account Info" section in your profile to update your details easily.',
            ),
            _buildFAQItem(
              context,
              'Who can use this app?',
              'This app is suitable for anyone looking for an intuitive and reliable task management tool.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}