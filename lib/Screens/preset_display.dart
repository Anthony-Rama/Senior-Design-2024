import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/preset.dart';

class PresetDisplayScreen extends StatelessWidget {
  final PresetRoute route;

  const PresetDisplayScreen({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ROUTE PREVIEW',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route Name: ${route.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Difficulty: ${route.difficulty}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Add more details about the route as needed
          ],
        ),
      ),
    );
  }
}
