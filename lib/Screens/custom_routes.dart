import 'package:flutter/material.dart';

class CustomRoutes extends StatefulWidget {
  const CustomRoutes({super.key});

  @override
  _CustomRoutesState createState() => _CustomRoutesState();
}

class _CustomRoutesState extends State<CustomRoutes> {
  List<Map<String, String>> customRoutes = [
    {'routeName': 'Custom Route 1', 'date': '2024-02-10', 'time': '10:00'},
    {'routeName': 'Custom Route 2', 'date': '2024-02-10', 'time': '12:30'},
    // TODO: Implement the logic to fetch custom routes from Firebase
  ];

  @override
  Widget build(BuildContext context) {
    List<String> routeNames =
        customRoutes.map((route) => route['routeName'] ?? '').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Custom Routes',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to the grid to create a new custom route
        },
        backgroundColor: Colors.red[400],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: routeNames.length,
        itemBuilder: (context, index) {
          final routeName = routeNames[index];
          return ListTile(
            title: Text(routeName),
            onTap: () {
              // TODO: Implement logic to edit custom route when tapped
            },
          );
        },
      ),
    );
  }
}
