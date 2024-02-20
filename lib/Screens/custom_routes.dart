import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/home_screen.dart';
import 'package:mobileapp/Screens/leaderboards.dart';
import 'package:mobileapp/Screens/preset.dart';
import 'package:mobileapp/Screens/stats.dart';

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

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'CUSTOM ROUTES',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to the grid to create a new custom route
        },
        backgroundColor: Colors.red[400],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.5,
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
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                        const HomeScreen(), //TODO: change to settings screen
                  ),
                );
              },
            ),
          ],
        ),
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
