import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/view/widget/auth_textfield.dart';
import 'package:urecycle_app/services/auth_service.dart';
import 'package:urecycle_app/view/screen/user_screen/user_screen.dart';
import 'package:urecycle_app/view/screen/admin_screen/admin_screen.dart';
import 'package:urecycle_app/view/widget/loading_widget.dart';
import '../../provider/admin_provider.dart';
import '../../provider/user_provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController studentIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final responseData = await _authService.loginUser(
          studentNumber: studentIDController.text,
          password: passwordController.text,
        );

        if (!mounted) return;

        final user = responseData['user'];
        final String role = user['role'];

        // Save the role and login state to Hive
        final box = await Hive.openBox('app_data');
        await box.put('userRole', role); // Store the role in Hive
        await box.put('isLoggedIn', true); // Store login state in Hive

        if (role == 'admin') {
          final adminProvider = Provider.of<AdminProvider>(context, listen: false);
          await adminProvider.fetchAdminData();
          await adminProvider.fetchDisposalData();

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const LoadingPage(),
          );

          await Future.delayed(const Duration(seconds: 2));

          if (!mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminScreen(role: 'admin')),
                (Route<dynamic> route) => false,
          );
        } else if (role == 'student') {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          await userProvider.fetchUserData();
          await userProvider.fetchNotifications();
          await userProvider.fetchTransactions();
          await userProvider.fetchTotalDisposals();

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const LoadingPage(),
          );

          await Future.delayed(const Duration(seconds: 1));

          if (!mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const UserScreen(role: 'student')),
                (Route<dynamic> route) => false,
          );
        } else {
          throw Exception('Invalid role');
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Constants.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.4, // Maintain the aspect ratio of the image
                      child: Image.asset(
                        "assets/icon/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 30),
                    AuthTextField(
                      controller: studentIDController,
                      hintText: "Student ID",
                      icon: Icons.person,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Your Student ID Number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    AuthTextField(
                      controller: passwordController,
                      hintText: "Password",
                      icon: Icons.vpn_key,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return "Password is required for login";
                        }
                        if (!regex.hasMatch(value)) {
                          return "Enter Valid Password (Min. 6 Characters)";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 35),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: _login,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          width: screenWidth * 0.8, // Responsive width
                          alignment: Alignment.center,
                          child: const Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Uncomment if needed
                    // const SizedBox(height: 15),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     const Text(
                    //       "Don't have an account? ",
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => const RegistrationScreen(),
                    //           ),
                    //         );
                    //       },
                    //       child: const Text(
                    //         "Sign Up",
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 15,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}