import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ForgotPassScreen(),
    );
  }
}

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController _emailController = TextEditingController();
  //final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    //_passwordController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content:
                  Text('The password reset link has been sent to your email!'),
            );
          },
        );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          },
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              'FORGOT PASSWORD',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red[400],
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Please enter your email, a reset link will be sent.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 239, 83, 80)),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        hintText: 'Enter email', prefixIcon: Icon(Icons.email)),
                  ),
                  /*const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'Enter New Password',
                        prefixIcon: Icon(Icons.lock)),
                  ),*/
                  /*const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Confirm New Password',
                prefixIcon: Icon(Icons.lock)
              ),
            ),*/
                  const SizedBox(height: 30),
                  MaterialButton(
                    onPressed: passwordReset,
                    color: Colors.red[400],
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Text('Reset Password'),
                  )
                  /*const Text(
                'Reset Password', 
                style: TextStyle(color: Color.fromARGB(255, 239, 83, 80))),*/
                ],
              )));
    }

    /*@override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }*/
  }

