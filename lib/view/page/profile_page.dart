import 'package:flutter/material.dart';
import 'package:urecycle_app/view/widget/profile_widget.dart';
import 'package:urecycle_app/model/user_model.dart';
import 'package:urecycle_app/constants.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';

class Profile extends StatefulWidget {
  final UserModel? user;

  const Profile({super.key, this.user});

  @override
  State createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();
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

    final initials = widget.user != null
        ? '${widget.user!.firstName[0].toUpperCase()}${widget.user!.lastName[0].toUpperCase()}'
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
                    '${widget.user?.firstName ?? 'Loading...'} ${widget.user?.lastName ?? ''}',
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.user?.email ?? 'Loading...',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
