import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/custom_routes.dart';
import 'package:mobileapp/Screens/feed.dart';
import 'package:mobileapp/Screens/leaderboards.dart';
import 'package:mobileapp/Screens/login.dart';
import 'package:mobileapp/Screens/preset.dart';
import 'package:mobileapp/Screens/stats.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLUTTER DEMO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('SETTINGS', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[400],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            const Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                SizedBox(width: 10),
                Text('Account',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 239, 83, 80)))
              ],
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 20),
            buildAccountOption(context, 'Change Password'),
            const SizedBox(height: 10),
            buildAccountOption(context, 'Change email'),
            const SizedBox(height: 10),
            buildAccountOption(context, 'Change First Name'),
            const SizedBox(height: 10),
            buildAccountOption(context, 'Change Last Name')
          ],
        ),
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
              title: const Text('Bellboard Feed'),
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

GestureDetector buildAccountOption(BuildContext context, String title) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext conext) {
            return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'New'),
                    ),
                    //const SizedBox(height: 10),
                    //TextFormField(
                    //  decoration: InputDecoration(labelText: 'Confirm $title'),
                    //),
                  ],
                ),
                actions: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 239, 83, 80)))),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); //TO DO: change logi to change password
                            },
                            child: const Text('Save',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 239, 83, 80))))
                      ])
                ]);
          });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey)
        ],
      ),
    ),
  );
}
