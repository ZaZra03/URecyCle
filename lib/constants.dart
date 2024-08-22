import 'package:flutter/material.dart';

class Constants {
  //Primary color
  static var primaryColor = const Color(0xFF5DB075);
  static var primary01Color = const Color(0xFF4B9460);
  static var primary02Color = const Color(0xFF6ABF8B);
  static var blackColor = Colors.black54;

  //Gray color
  static var gray01Color = const Color(0xFFF6F6F6);
  static var gray02Color = const Color(0xFFE8E8E8);
  static var gray03Color = const Color(0xFFBDBDBD);
  static var gray04Color = const Color(0xFF666666);

  //Routes
  static const url = 'http://10.133.66.64:3000/';
  static const register = '${url}register';
  static const login = '${url}login';
  static const leaderboard = '${url}leaderboard';
  static const user = '${url}user';

  //Onboarding texts
  static var titleOne = "Learn more about plants";
  static var descriptionOne = "Read how to care for plants in our rich plants guide.";
  static var titleTwo = "Find a plant lover friend";
  static var descriptionTwo = "Are you a plant lover? Connect with other plant lovers.";
  static var titleThree = "Plant a tree, green the Earth";
  static var descriptionThree = "Find almost all types of plants that you like here.";
}