import 'package:flutter/material.dart';
import '../../../constants.dart';

class SGDScreen extends StatelessWidget {
  const SGDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SGD 12',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sustainable Development Goal 12',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ensure sustainable consumption and production patterns.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              const Text(
                'Goal 12 emphasizes the importance of reducing waste and ensuring sustainable consumption and production patterns. '
                    'One critical aspect of this goal is the effective management of waste, particularly the distinction between recycled waste and trash waste.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recycled Waste vs. Trash Waste:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                      text: '1. ',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: 'Recycled Waste: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'This refers to materials that can be processed and repurposed into new products. '
                          'Common recyclable materials include paper, glass, metals, and certain plastics. '
                          'By recycling, we conserve natural resources, reduce energy consumption, and minimize pollution.\n\n',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: '2. ',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: 'Trash Waste: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'This includes non-recyclable materials that typically end up in landfills. '
                          'Trash waste contributes to environmental degradation, as landfills can produce harmful emissions and take up valuable land space. '
                          'Reducing trash waste is essential for sustainable waste management.',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Key Actions to Improve Waste Management:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '1. Increase awareness about the importance of recycling and proper waste segregation.\n'
                    '2. Implement community recycling programs to encourage participation.\n'
                    '3. Support legislation aimed at reducing single-use plastics and promoting sustainable materials.\n'
                    '4. Encourage businesses to adopt circular economy practices, reducing waste through innovative design and materials.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
