import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/preset.dart';
import 'package:mobileapp/Screens/custom_routes.dart';
import 'package:mobileapp/Screens/stats.dart';
import 'package:mobileapp/Screens/leaderboards.dart';
import 'package:mobileapp/Screens/settings.dart';
import 'package:mobileapp/Screens/login.dart';
import 'package:mobileapp/platforms/social_media_platform.dart';

class sideMenu extends StatelessWidget {
  const sideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            title: const Text('Social'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MobileScreenLayout()),
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
    );
  }
}
