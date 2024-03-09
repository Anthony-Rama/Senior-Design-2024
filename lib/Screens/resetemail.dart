import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobileapp/Screens/login.dart';

class ResetEmailScreen extends StatefulWidget {
  @override
  _ResetEmailScreenState createState() => _ResetEmailScreenState();
}

class _ResetEmailScreenState extends State<ResetEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentEmailController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
        Text('Change Email',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red[400],
        leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
      );},
      icon: Icon(Icons.arrow_back, color: Colors.white,
      ),
      ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentEmailController,
                decoration: InputDecoration(hintText: 'Current Email', prefixIcon: const Icon(Icons.email),),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your current email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newEmailController,
                decoration: InputDecoration(hintText: 'New Email',prefixIcon: const Icon(Icons.email),),
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
                decoration: InputDecoration(hintText: 'Password',prefixIcon: const Icon(Icons.lock),),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String currentEmail = _currentEmailController.text;
                    String newEmail = _newEmailController.text;
                    String password = _passwordController.text;

                    try {
                      // Re-authenticate the user
                      AuthCredential credential = EmailAuthProvider.credential(
                        email: currentEmail,
                        password: password,
                      );
                      await _auth.currentUser!.reauthenticateWithCredential(credential);

                      // Update the user's email
                      // ignore: deprecated_member_use
                      await _auth.currentUser!.verifyBeforeUpdateEmail(newEmail);

                      // Show success message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Success'),
                            content: Text('A verification link has been sent to your email, please verify by clicking the link.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK', style: TextStyle(color: Colors.red[400]),),
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
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red[400]!),),
                child: Text('Reset Email',
                        style:TextStyle(color: Colors.white),),
              ),
              SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
}
}





/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ResetEmailScreen(),
    );
  }
}

class ResetEmailScreen extends StatefulWidget {
  const ResetEmailScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResetEmailScreenState createState() => _ResetEmailScreenState();
}

class _ResetEmailScreenState extends State<ResetEmailScreen> {
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
                  Text('The email reset link has been sent to your new email!'),
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
              'RESET EMAIL',
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
                    'Please enter your ADD SHIT HERE, a reset link will be sent.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 239, 83, 80)),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        hintText: 'Enter email', prefixIcon: Icon(Icons.email)),
                  ),
                  
                  const SizedBox(height: 30),
                  MaterialButton(
                    onPressed: passwordReset,
                    color: Colors.red[400],
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Text('Reset Email'),
                  )
                ],
              )));
    }

   
  }
*/

