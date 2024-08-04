import 'package:flutter/material.dart';

void handleTap(BuildContext context, Widget destinationPage) {
  Future.delayed(const Duration(milliseconds: 100), () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationPage),
    );
  });
}