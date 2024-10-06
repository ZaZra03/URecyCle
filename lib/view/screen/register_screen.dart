import 'package:flutter/material.dart';
import 'package:urecycle_app/constants.dart';
import 'package:urecycle_app/view/widget/auth_textfield.dart';
// import 'package:urecycle_app/view/user_screen.dart';
import 'package:urecycle_app/services/auth_service.dart';

// import '../utils/navigation_utils.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final studentIDEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  String? selectedCollege = '';

  final AuthService _authService = AuthService();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _authService.registerUser(
          firstName: firstNameEditingController.text,
          lastName: lastNameEditingController.text,
          studentNumber: studentIDEditingController.text,
          college: selectedCollege ?? '',
          email: emailEditingController.text,
          password: passwordEditingController.text,
        );

        if (!mounted) return;

        // Clear all input fields
        setState(() {
          firstNameEditingController.clear();
          lastNameEditingController.clear();
          studentIDEditingController.clear();
          emailEditingController.clear();
          passwordEditingController.clear();
          confirmPasswordEditingController.clear();
          selectedCollege = ''; // Reset dropdown to the default value
        });

        // Unfocus any selected text field
        FocusScope.of(context).unfocus();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful: ${response['message']}')),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> collegeMap = {
      '': '',
      'College of Arts and Sciences': 'CAS',
      'College of Business Accountancy and Administration': 'CBAA',
      'College of Computing Studies': 'CCS',
      'College of Education': 'COED',
      'College of Engineering': 'COE',
      'College of Health and Allied Sciences': 'CHAS',
    };

    final double imageHeight = MediaQuery.of(context).size.width * 0.4; // Adjust the multiplier as needed

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
                    height: imageHeight, // Responsive image height
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
                            if (value == null || value.isEmpty) {
                              return "*Required";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: AuthTextField(
                          controller: lastNameEditingController, // Updated variable name here
                          hintText: "Last name",
                          icon: Icons.account_circle,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "*Required";
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
                      if (value == null || value.isEmpty) {
                        return "*Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedCollege,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black, width: 2), // Border style
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    isExpanded: true,
                    items: collegeMap.keys.map((String college) {
                      return DropdownMenuItem<String>(
                        value: collegeMap[college], // Use the internal value here
                        child: Text(college),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCollege = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '') {
                        return 'Please select a college';
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
                      if (value == null || value.isEmpty) {
                        return "*Required";
                      }
                      if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                        return "Invalid email";
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
                      if (value == null || value.isEmpty) {
                        return "*Required";
                      }
                      if (!regex.hasMatch(value)) {
                        return "Must be minimum of 6 characters";
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
                      if (value != passwordEditingController.text) {
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
