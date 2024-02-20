import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/custom_routes.dart';
import 'package:mobileapp/Screens/feed.dart';
import 'package:mobileapp/Screens/leaderboards.dart';
import 'package:mobileapp/Screens/login.dart';
import 'package:mobileapp/Screens/preset.dart';
import 'package:mobileapp/Screens/settings.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  List<Map<String, String>> completedRoutes = [
    {'routeName': 'Route 1', 'date': '2024-02-10', 'time': '10 min'},
    {'routeName': 'Route 2', 'date': '2024-02-10', 'time': '20 min'},
    //TODO: Implement the logic to fetch completed routes from Firebase
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'COMPLETED ROUTES',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: completedRoutes.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Route Name',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Date',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Time',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            final route = completedRoutes[index - 1];
            return ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        route['routeName'] ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        route['date'] ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        route['time'] ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 123,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red[400],
                ),
                child: const Center(
                  child: Text(
                    'MENU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Feed'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Preset Routes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PresetScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Custom Routes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomRoutes()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Stats'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Stats()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Leaderboards'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Leaderboards()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SettingsScreen(), //TODO: change to settings screen
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Implement user logout logic (e.g., clearing user session)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
