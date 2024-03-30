import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/Screens/addpfp.dart';
//import 'package:mobileapp/Screens/verifyemail.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> registerUser(BuildContext context) async {
    try {
      var existingUser = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(_emailController.text);
      if (existingUser.isNotEmpty) {
        throw 'Email already in use';
      }

      var userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: _usernameController.text)
          .get();
      if (userQuery.docs.isNotEmpty) {
        throw 'Username already in use';
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': _firstnameController.text,
        'lastName': _lastnameController.text,
        'email': _emailController.text,
        'username': _usernameController.text,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddPFPScreen()),
      );
    } catch (e) {
      print('Error signing up: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing up: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
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
              _buildTextFieldWithIcon(
                  Icons.person, 'First Name', _firstnameController),
              const SizedBox(height: 10),
              _buildTextFieldWithIcon(
                  Icons.person, 'Last Name', _lastnameController),
              const SizedBox(height: 10),
              _buildTextFieldWithIcon(Icons.email, 'Email', _emailController),
              const SizedBox(height: 10),
              _buildTextFieldWithIcon(
                  Icons.person, 'Username', _usernameController),
              const SizedBox(height: 10),
              _buildTextFieldWithIcon(
                  Icons.lock, 'Password', _passwordController,
                  isPassword: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // check if any field is empty
                  if (_firstnameController.text.isEmpty ||
                      _lastnameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _usernameController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Call the registerUser function
                  registerUser(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon(
      IconData icon, String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}