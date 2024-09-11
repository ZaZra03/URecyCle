import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urecycle_app/services/firebase_service.dart';
import 'view/login_screen.dart';
import 'provider/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:urecycle_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications(); // Initialize notifications here

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(), // No need to initialize notifications here
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
