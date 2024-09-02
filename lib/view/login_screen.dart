import 'package:flutter/material.dart';
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/view/widget/auth_textfield.dart';
import 'package:urecycle_app/services/auth_service.dart';
import 'package:urecycle_app/view/user_screen.dart';
import 'package:urecycle_app/view/admin_screen.dart';
// import 'package:urecycle_app/view/register_screen.dart';

// import '../utils/navigation_utils.dart';

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

        final user = responseData['user'];
        final String role = user['role'];

        if (!mounted) return;

        // Navigate based on role or handle accordingly
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserScreen()),
          );
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
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        "assets/icon/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 45),
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
                          return "Enter Valid Password(Min. 6 Character)";
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
                          width: MediaQuery.of(context).size.width,
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

