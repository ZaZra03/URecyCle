import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/login_screen.dart';
import 'view/user_screen.dart';
import 'provider/user_provider.dart'; // Import your UserProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(), // Provide the UserProvider
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginScreen(), // LoginScreen as the initial screen
      ),
    );
  }
}
