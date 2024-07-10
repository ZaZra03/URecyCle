import 'package:flutter/material.dart';
import 'package:urecycle_app/widget/bottom_navigation.dart'; // Adjust the import path based on your project structure

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BottomNavBar(),
    );
  }
}

