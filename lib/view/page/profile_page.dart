import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../../provider/admin_provider.dart'; // Import AdminProvider
import 'package:urecycle_app/view/widget/profile_widget.dart';
import 'package:urecycle_app/constants.dart';
import '../../services/auth_service.dart';
import '../screen/login_screen.dart';
import '../widget/loading_widget.dart';

class Profile extends StatefulWidget {
  final String role; // Accept role as a parameter

  const Profile({super.key, required this.role});

  @override
  State createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();

    // Ensure that the correct provider's fetchData method is called based on the role
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.role == 'admin') {
        // Fetch admin data if the user is an admin
        final adminProvider = Provider.of<AdminProvider>(context, listen: false);
        if (adminProvider.user == null) {
          adminProvider.fetchAdminData();
        }
      } else {
        // Fetch student data if the user is a student
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (userProvider.user == null || userProvider.lbUser == null) {
          userProvider.fetchUserData();
        }
      }
    });
  }

  Future<void> _logout() async {
    // Show loading page
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (context) => const LoadingPage(),
    );

    if (widget.role == 'admin') {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      adminProvider.reset();
    } else {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.reset();
    }

    await AuthService().logout();

    await Future.delayed(const Duration(seconds: 1));

    // Check if the widget is still mounted before navigating
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

    // Access the correct provider based on the role
    final userProvider = widget.role == 'student' ? Provider.of<UserProvider>(context) : null;
    final adminProvider = widget.role == 'admin' ? Provider.of<AdminProvider>(context) : null;

    // Get the user object from the respective provider
    final user = widget.role == 'admin' ? adminProvider?.user : userProvider?.user;

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

              // Display profile information based on the role
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
