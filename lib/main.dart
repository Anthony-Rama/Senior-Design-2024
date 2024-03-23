import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'backend_resources/firebase_options.dart';
import 'package:mobileapp/Screens/login.dart';
import 'package:mobileapp/Screens/signup.dart';
import 'package:mobileapp/platforms/social_media_platform.dart';
import 'package:mobileapp/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase initialized successfully');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap MaterialApp with ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/signup': (context) => SignUpScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MobileScreenLayout(),
        },
      ),
    );
  }
}
