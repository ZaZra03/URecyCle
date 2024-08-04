import 'package:flutter/material.dart';
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/view/widget/auth_textfield.dart';
import 'package:urecycle_app/view/user_screen.dart';
import 'package:urecycle_app/services/auth_service.dart';

import '../utils/navigation_utils.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final studentIDEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _authService.registerUser(
          firstName: firstNameEditingController.text,
          lastName: secondNameEditingController.text,
          studentNumber: studentIDEditingController.text,
          email: emailEditingController.text,
          password: passwordEditingController.text,
        );

        // Check if the widget is still mounted before showing a SnackBar
        if (!mounted) return;

        handleTap(context, const UserScreen());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful: ${response['message']}')),
        );
      } catch (e) {
        // Check if the widget is still mounted before showing a SnackBar
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Constants.primaryColor,
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 170,
                    child: Image.asset(
                      "assets/icon/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: AuthTextField(
                          controller: firstNameEditingController,
                          hintText: "First name",
                          icon: Icons.account_circle,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            RegExp regex = RegExp(r'^.{3,}$');
                            if (value!.isEmpty) {
                              return ("First Name cannot be Empty");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Valid name (Min. 3 Characters)");
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: AuthTextField(
                          controller: secondNameEditingController,
                          hintText: "Last name",
                          icon: Icons.account_circle,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Last Name cannot be Empty");
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: studentIDEditingController,
                    hintText: "Student ID",
                    icon: Icons.account_circle,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Student ID cannot be Empty");
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: emailEditingController,
                    hintText: "Email",
                    icon: Icons.mail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter Your Email");
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                        return ("Please Enter a valid email");
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: passwordEditingController,
                    hintText: "Password",
                    icon: Icons.vpn_key,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return ("Password is required for login");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid Password (Min. 6 Characters)");
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: confirmPasswordEditingController,
                    hintText: "Confirm Password",
                    icon: Icons.vpn_key,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (confirmPasswordEditingController.text != passwordEditingController.text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _register,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: const Text(
                          "Sign Up",
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
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
