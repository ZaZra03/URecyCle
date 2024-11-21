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
              'What is URecyCle?',
              'URecyCle is an innovative app designed to promote recycling and sustainable waste management at University of Cabuyao. It helps users track recycling efforts, view leaderboards, and access waste disposal analytics.',
            ),
            _buildFAQItem(
              context,
              'How do I scan items for recycling?',
              'Go to the Scan page by tapping the round button at the bottom of the screen. Then, scan the QR code located in the bin areas and use the scanner to identify recyclable items.',
            ),
            _buildFAQItem(
              context,
              'Who can use URecyCle?',
              'URecyCle is for enrolled students of University of Cabuyao aiming to make a positive environmental impact through better waste management practices.',
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