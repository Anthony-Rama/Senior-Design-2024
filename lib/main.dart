import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/login.dart';
import 'package:mobileapp/SocialMedia/feed.dart';
import 'package:mobileapp/Screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase initialized successfully');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define initial route as login screen
      initialRoute: '/login',
      // Define routes
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const FeedScreen(),
      },
    );
  }
}
