import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BellBoard Sign Up', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
  padding: EdgeInsets.all(16.0),
  child: Center(
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

            SizedBox(height: 20),
            _buildTextFieldWithIcon(Icons.person, 'First Name'),
            SizedBox(height: 10),
            _buildTextFieldWithIcon(Icons.person, 'Last Name'),
            SizedBox(height: 10),
            _buildTextFieldWithIcon(Icons.email, 'Email'),
            SizedBox(height: 10),
            _buildTextFieldWithIcon(Icons.lock, 'Password', isPassword: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Firebase logic
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red[400], 
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon(IconData icon, String hintText,
      {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }
}