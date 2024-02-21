import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/login.dart';
import 'package:mobileapp/SocialMedia/feed.dart';
import 'package:mobileapp/Screens/signup.dart';

void main() {
  runApp(const MyApp());
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
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const FeedScreen(),
      },
    );
  }
}
