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

  //Constant Variables
  static const Map<String, String> categoryMapping = {
    'Aluminum Cans': 'Metal',
    'Cardboard Boxes': 'Cardboard',
    'Disposable Plastic Cutlery': 'Plastic',
    'Glass Containers': 'Glass',
    'Organic Waste': 'Trash',
    'Paper': 'Paper',
    'Paper Cups': 'Paper',
    'Plastic Bags': 'Plastic',
    'Plastic Bottles': 'Plastic',
    'Plastic Cups': 'Plastic',
    'Plastic Food Containers': 'Plastic',
    'Plastic Straws': 'Plastic',
    'Styrofoam': 'Trash',
  };

  static const Map<String, int> pointsMapping = {
    'Aluminum Cans': 15,
    'Cardboard Boxes': 10,
    'Disposable Plastic Cutlery': 3,
    'Glass Containers': 20,
    'Organic Waste': 0,
    'Paper': 8,
    'Paper Cups': 5,
    'Plastic Bags': 2,
    'Plastic Bottles': 10,
    'Plastic Cups': 5,
    'Plastic Food Containers': 8,
    'Plastic Straws': 1,
    'Styrofoam': 0,
  };

  //Routes
  // static const url = 'https://urecycle-backend.onrender.com/';
  static const url = 'http://192.168.18.10:3000/';
  static const register = '${url}register';
  static const login = '${url}login';
  static const leaderboard = '${url}leaderboard';
  static const lbTop3 = '${url}top-entries';
  static const user = '${url}user';
  static const acceptingWaste = '${url}acceptingWaste';
  static const allUsers = '${url}all-users';
  static const sendNotification = '${url}send-notification';
  static const getNotification = '${url}notifications';
  static const createTransaction = '${url}transactions';
  static const totalDisposals = '${url}total-disposal';
  static const allDisposals = '${url}all-disposal';
  static const weeklyDisposals = '${url}weekly-disposal';
  static const allBinStates = '${url}binstate';
  static const toggleBinState = '${url}binstate';
}