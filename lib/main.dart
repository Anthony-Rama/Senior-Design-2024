import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/login.dart';
import 'package:mobileapp/SocialMedia/feed.dart';
import 'package:mobileapp/Screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';

/*void main() {
  runApp(const MyApp());
}*/

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBf5wIfnaabJW3Jqw9bJjVEbwXCSNNIOaw", 
        appId: "1:1062001949517:web:96aad9bcaeffc8b6375504",
        messagingSenderId: "1062001949517",
        projectId: "bellboard-2024",
        storageBucket: 'bellboard-2024.appspot.com'
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
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
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const FeedScreen(),
      },
    );
  }
}