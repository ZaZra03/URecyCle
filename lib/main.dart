import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urecycle_app/provider/admin_provider.dart';
import 'package:urecycle_app/services/firebase_service.dart';
import 'package:urecycle_app/services/hive_service.dart';
import 'package:urecycle_app/view/screen/admin_screen/admin_screen.dart';
import 'package:urecycle_app/view/screen/user_screen/user_screen.dart';
import 'view/screen/login_screen.dart';
import 'provider/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:urecycle_app/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase API and Notifications
  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize HiveService
  final hiveService = HiveService();
  await hiveService.init(); // Initialize Hive and open boxes

  runApp(MyApp(firebaseApi: firebaseApi));
}

class MyApp extends StatelessWidget {
  final FirebaseApi firebaseApi;

  const MyApp({
    super.key,
    required this.firebaseApi,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // Navigate based on login state and role
        home: Builder(builder: (context) {
          final userBox = HiveService().userBox; // Access the userBox here
          final user = userBox.get('user'); // Get the user instance
          print(user);

          // Check if user exists and determine the role
          if (user == null) {
            return const LoginScreen(); // No user found
          } else if (user.role == 'admin') {
            return const AdminScreen(role: 'admin'); // Admin role
          } else {
            return const UserScreen(role: 'user'); // Regular user
          }
        }),
      ),
    );
  }
}
