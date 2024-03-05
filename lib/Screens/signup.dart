import 'package:flutter/material.dart';
import 'package:mobileapp/SocialMedia/feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BellBoard Sign Up',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: const Center(
                child: Text(
                  'Reach New Heights',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextFieldWithIcon(Icons.person, 'First Name', _firstnameController),
            const SizedBox(height: 10),
            _buildTextFieldWithIcon(Icons.person, 'Last Name', _lastnameController),
            const SizedBox(height: 10),
            _buildTextFieldWithIcon(Icons.email, 'Email', _emailController),
            const SizedBox(height: 10),
            _buildTextFieldWithIcon(Icons.person, 'Username', _usernameController),
            const SizedBox(height: 10),
            _buildTextFieldWithIcon(Icons.lock, 'Password', _passwordController, isPassword: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                //TODO: Placeholder for SIGNUP logic
                 try {
                  // Sign up the user using Firebase Authentication
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );

                  // Get the user ID
                  String userId = userCredential.user!.uid;

                  // Save additional user information to Firestore database
                  await FirebaseFirestore.instance.collection('users').doc(userId).set({
                    'firstName': _firstnameController.text,
                    'lastName': _lastnameController.text,
                    'email': _emailController.text,
                    'username': _usernameController.text,
                 });

                  // Navigate to the next screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const FeedScreen()),
                  );
                } catch (e) {
                  
                  print('Error signing up: $e');
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error signing up: $e'),
                      backgroundColor: Colors.red,));
                
                
                /*String res = await AuthMethods().signUpUser(
                  email: _emailController.text,
                  password: _passwordController.text,
                  username: _usernameController.text,
                  firstname: _firstnameController.text,
                  lastname: _lastnameController.text,
                )*/

                /*Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedScreen()),
                );*/
              }},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
             ), //child: null,
          ],
        ),
    ));
  }

  Widget _buildTextFieldWithIcon(IconData icon, String hintText, TextEditingController firstnameController,
      {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}