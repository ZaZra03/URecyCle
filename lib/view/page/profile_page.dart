import 'package:flutter/material.dart';
import 'package:urecycle_app/view/widget/profile_widget.dart';
import 'package:urecycle_app/model/user_model.dart';
import 'package:urecycle_app/constants.dart';
import '../../utils/userdata_utils.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel? _user;
  bool _isLoading = true;
  final Uri url = Uri.parse(Constants.user);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await fetchUserData(url);

      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error appropriately
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final initials = _user != null
        ? '${_user!.firstName[0].toUpperCase()}${_user!.lastName[0].toUpperCase()}'
        : '';

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 25.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Constants.primaryColor.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _user?.firstName ?? 'Loading...',
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    _user?.email ?? 'Loading...',
                    style: TextStyle(
                      color: Constants.blackColor.withOpacity(.3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SingleChildScrollView(
                child: SizedBox(
                  height: size.height * .7,
                  width: size.width,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileWidget(
                        icon: Icons.settings,
                        title: 'Account Settings',
                      ),
                      ProfileWidget(
                        icon: Icons.logout,
                        title: 'Log Out',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}