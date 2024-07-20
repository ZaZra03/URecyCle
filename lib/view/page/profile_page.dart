import 'package:flutter/material.dart';
import 'package:urecycle_app/view/widget/profile_widget.dart';
import 'package:urecycle_app/constants.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                child: CircleAvatar(
                  radius: 60, // Adjusts the size of the CircleAvatar
                  backgroundColor: Colors.grey,
                  child: const Text(
                    "EM",
                    style: TextStyle(
                      fontSize: 24, // Adjusts the text size
                      color: Colors.white, // Sets the text color to white
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Constants.primaryColor.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ezra Micah Malsi',
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'ezramalsi@gmail.com',
                    style: TextStyle(
                      color: Constants.blackColor.withOpacity(.3),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              // Wrap the following Column with SingleChildScrollView
              SingleChildScrollView(
                child: SizedBox(
                  height: size.height * .7,
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
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
