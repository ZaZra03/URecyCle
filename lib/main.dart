import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urecycle_app/provider/admin_provider.dart';
import 'package:urecycle_app/services/firebase_service.dart';
import 'view/screen/login_screen.dart';
import 'provider/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:urecycle_app/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Handle background messages here
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize FirebaseApi
  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(firebaseApi: firebaseApi));
}

class MyApp extends StatelessWidget {
  final FirebaseApi firebaseApi;

  const MyApp({super.key, required this.firebaseApi});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
