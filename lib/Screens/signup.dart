import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/home_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
            _buildTextFieldWithIcon(Icons.person, 'First Name'),
            const SizedBox(height: 10),
            _buildTextFieldWithIcon(Icons.person, 'Last Name'),
            const SizedBox(height: 10),
            _buildTextFieldWithIcon(Icons.email, 'Email'),
            const SizedBox(height: 10),
            _buildTextFieldWithIcon(Icons.lock, 'Password', isPassword: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //TODO: Placeholder for SIGNUP logic
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
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
    );
  }

  Widget _buildTextFieldWithIcon(IconData icon, String hintText,
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
