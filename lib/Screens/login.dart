import 'package:flutter/material.dart';
import 'package:mobileapp/SocialMedia/feed.dart';
import 'package:mobileapp/Screens/forgotpassword.dart';
import 'package:mobileapp/Screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobileapp/platforms/social_media_platform.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /*@override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  */
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
                            //labelText: 'Email',
                            hintText: 'Enter email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onChanged: (String
                              value) {}, // add login logic for email in here i think
                          validator: (value) {
                            return value!.isEmpty ? 'Please enter email' : null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            //labelText: 'Password',
                            hintText: 'Enter password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onChanged: (String
                              value) {}, // add login logic for password here i think
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter password'
                                : null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        //child: ClipRRect(
                        //borderRadius: BorderRadius.circular(20),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () async {
                            try {
                              // Sign in the user using Firebase Authentication
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              // Navigate to the feed screen after successful login
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MobileScreenLayout()),
                              );
                            } catch (e) {
                              // Handle errors
                              print('Error signing in: $e');
                              // Display error message to the user
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error signing in: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            /*Navigator.push(
                           context,
                            MaterialPageRoute(
                            builder: (context) => const FeedScreen()),
                          );*/
                          },
                          color: Colors.red[400],
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Text('Log in'),
                        ),
                      ),
                      // ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          'Dont have an account? Sign up!',
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
                      )
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

/*Future logIn() async {
  await FirebaseAuth.signInWithEmailAndPassword(
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
  );
}
*/