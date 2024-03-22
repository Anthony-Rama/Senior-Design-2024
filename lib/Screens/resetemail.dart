import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/Screens/login.dart';

class ResetEmailScreen extends StatefulWidget {
  const ResetEmailScreen({super.key});

  @override
  _ResetEmailScreenState createState() => _ResetEmailScreenState();
}

class _ResetEmailScreenState extends State<ResetEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentEmailController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Email',
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
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentEmailController,
                decoration: const InputDecoration(
                  hintText: 'Current Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your current email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newEmailController,
                decoration: const InputDecoration(
                  hintText: 'New Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your new email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String currentEmail = _currentEmailController.text;
                    String newEmail = _newEmailController.text;
                    String password = _passwordController.text;

                    try {
                      // reauthenticate user
                      AuthCredential credential = EmailAuthProvider.credential(
                        email: currentEmail,
                        password: password,
                      );
                      await _auth.currentUser!
                          .reauthenticateWithCredential(credential);

                      // update email
                      await _auth.currentUser!
                          .verifyBeforeUpdateEmail(newEmail);

                      // update email in firestore
                      await _firestore
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .update({'email': newEmail});

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Success'),
                            content: const Text(
                              'A verification link has been sent to your email, please verify by clicking the link.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()));
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(color: Colors.red[400]),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      setState(() {
                        _errorMessage = e.toString();
                      });
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red[400]!),
                ),
                child: const Text(
                  'Reset Email',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
