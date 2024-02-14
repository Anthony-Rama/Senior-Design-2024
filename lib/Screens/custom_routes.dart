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

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'CUSTOM ROUTES',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
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
            Container(
              height: 123,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red[400],
                ),
                child: Center(
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
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Preset Routes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PresetScreen(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Stats'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Stats()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Leaderboards'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Leaderboards()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Settings'),
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
