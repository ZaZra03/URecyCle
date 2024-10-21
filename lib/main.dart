import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:urecycle_app/provider/admin_provider.dart';
import 'package:urecycle_app/services/auth_service.dart';
import 'package:urecycle_app/services/firebase_service.dart';
import 'package:urecycle_app/view/page/scan_page/scan_page.dart';
import 'package:urecycle_app/view/screen/admin_screen.dart';
import 'package:urecycle_app/view/screen/user_screen.dart';
import 'model/leaderboard_model_hive.dart';
import 'model/user_model_hive.dart';
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Hive and open boxes
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // Register Hive adapters for custom data types
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(LeaderboardEntryAdapter());

  // Try opening Hive boxes and handling potential errors
  try {
    await Hive.openBox('userBox');
    await Hive.openBox('notificationsBox');
    await Hive.openBox('transactionsBox');
    await Hive.openBox('disposalBox');
  } catch (e) {
    print('Error opening Hive boxes: $e');
    // Consider showing an error UI or retrying
  }

  // Retrieve login information from Hive and SharedPreferences
  final userBox = Hive.box('userBox');
  bool isLoggedIn = userBox.get('isLoggedIn', defaultValue: false);
  String role = userBox.get('role', defaultValue: 'user');

  // Check if token exists in SharedPreferences
  final String? token = await AuthService.getToken();
  if (token != null) {
    isLoggedIn = true;
  }

  runApp(MyApp(firebaseApi: firebaseApi, isLoggedIn: isLoggedIn, role: role));
}

class MyApp extends StatelessWidget {
  final FirebaseApi firebaseApi;
  final bool isLoggedIn;
  final String role;

  const MyApp({
    super.key,
    required this.firebaseApi,
    required this.isLoggedIn,
    required this.role,
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
        // home: isLoggedIn
        //     ? (role == 'admin'
        //     ? const AdminScreen(role: 'admin')
        //     : const UserScreen(role: 'user'))
        //     : const LoginScreen(),
        home: const Scan(),
      ),
    );
  }
}
