import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import 'package:urecycle_app/view/widget/profile_widget.dart';
import 'package:urecycle_app/constants.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();

    // Ensure that fetchUserData is called after the widget has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user == null || userProvider.lbUser == null) {
        userProvider.fetchUserData();
      }
    });
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Access UserProvider
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user; // Get the user object from provider

    final initials = user != null
        ? '${user.firstName[0].toUpperCase()}${user.lastName[0].toUpperCase()}'
        : '';

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with user initials
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

              // User info
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${user?.firstName ?? 'Loading...'} ${user?.lastName ?? ''}',
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    user?.email ?? 'Loading...',
                    style: TextStyle(
                      color: Constants.blackColor.withOpacity(.3),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Profile options
              SizedBox(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileWidget(
                      icon: Icons.settings,
                      title: 'Account Settings',
                      onTap: () {
                        // Handle account settings tap
                      },
                    ),
                    ProfileWidget(
                      icon: Icons.logout,
                      title: 'Log Out',
                      onTap: _logout,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
