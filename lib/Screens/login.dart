import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/forgotpassword.dart';
import 'package:mobileapp/Screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobileapp/platforms/social_media_platform.dart';
import 'package:mobileapp/Screens/resetemail.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'WELCOME TO',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.red[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'THE BELLBOARD',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.red[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            errorText: _emailError,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                _emailError = 'Please enter your email';
                              });
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: 'Enter password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            errorText: _passwordError,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                _passwordError = 'Please enter your password';
                              });
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () async {
                            setState(() {
                              _emailError = null;
                              _passwordError = null;
                              _errorMessage = null;
                            });
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              setState(() {
                                if (_emailController.text.isEmpty) {
                                  _emailError = 'Please enter your email';
                                }
                                if (_passwordController.text.isEmpty) {
                                  _passwordError = 'Please enter your password';
                                }
                              });
                            } else {
                              try {
                                // sign in using Firebase Authentication
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                // navigate to feed screen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MobileScreenLayout()),
                                );
                              } catch (e) {
                                print('Error signing in: $e');
                                setState(() {
                                  _errorMessage =
                                      'Invalid email or password. Please try again.';
                                });
                              }
                            }
                          },
                          color: Colors.red[400],
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Text('Log in'),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          'Don\'t have an account? Sign up!',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassScreen()),
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ResetEmailScreen()));
                          },
                          child: Text('Reset Email',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red[400],
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
