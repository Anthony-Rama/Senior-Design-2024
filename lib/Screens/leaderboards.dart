import 'package:flutter/material.dart';

class Leaderboards extends StatelessWidget {
  const Leaderboards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Retrieve the list of users and their routes completed from Firebase
    final List<Map<String, dynamic>> users = [
      // Placeholder data, replace with actual data from Firebase
      {'name': 'John Doe', 'routes': 40},
      {'name': 'Jane Doe', 'routes': 39},
      {'name': 'Alice', 'routes': 50},
      {'name': 'Bob', 'routes': 37},
      {'name': 'Charlie', 'routes': 36},
      {'name': 'David', 'routes': 35},
      {'name': 'Eve', 'routes': 34},
      {'name': 'Frank', 'routes': 33},
      {'name': 'Grace', 'routes': 32},
      {'name': 'Heidi', 'routes': 31},
      {'name': 'Ivy', 'routes': 30},
      {'name': 'Jack', 'routes': 29},
      {'name': 'Karl', 'routes': 28},
      {'name': 'Liam', 'routes': 27},
      {'name': 'Mia', 'routes': 26},
      {'name': 'Nina', 'routes': 25},
      {'name': 'Oscar', 'routes': 24},
      {'name': 'Pam', 'routes': 23},
      {'name': 'Quinn', 'routes': 22},
      {'name': 'Riley', 'routes': 21},
      {'name': 'Sara', 'routes': 20},
      {'name': 'Tom', 'routes': 19},
      {'name': 'Uma', 'routes': 18},
      {'name': 'Vera', 'routes': 17},
      {'name': 'Will', 'routes': 16},
      {'name': 'Xander', 'routes': 15},
      {'name': 'Yara', 'routes': 14},
      {'name': 'Zane', 'routes': 13},
    ];

    users.sort((a, b) => b['routes'].compareTo(a['routes']));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
                width: double.infinity,
                height: 10), // Provides spacing and width
            Expanded(
              child: ListView.separated(
                itemCount: users.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user['name']),
                    trailing: Text('${user['routes']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
