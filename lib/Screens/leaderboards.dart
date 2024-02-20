import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/custom_routes.dart';
import 'package:mobileapp/Screens/home_screen.dart';
import 'package:mobileapp/Screens/preset.dart';
import 'package:mobileapp/Screens/stats.dart';

class Leaderboards extends StatelessWidget {
  const Leaderboards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'LEADERBOARDS', //TODO: Replace "username" with user.id from Firebase
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: buttonWidth,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red[400],
                  side: const BorderSide(color: Colors.red, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                ),
                onPressed: () {
                  // TODO: Placeholder for navigation or connection logic for the bellboard and other screens
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GlobalLeaderboard(),
                    ),
                  );
                },
                child: const Text(
                  'GLOBAL LEADERBOARD',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: buttonWidth,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red[400],
                  side: const BorderSide(color: Colors.red, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                ),
                onPressed: () {
                  // TODO: Placeholder for navigation or functionality for preset routes and other screens
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SquadLeaderboard(),
                    ),
                  );
                },
                child: const Text(
                  'SQUAD LEADERBOARD',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
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
    );
  }
}

// Global Leaderboards Screen
class GlobalLeaderboard extends StatelessWidget {
  const GlobalLeaderboard({Key? key}) : super(key: key);

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
          title: const Text(
            'LEADERBOARDS',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[400],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Leaderboards()),
                );
              })),
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

// Squad Leaderboards Screen
class SquadLeaderboard extends StatelessWidget {
  const SquadLeaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Replace this placeholder data with group data retrieved from the backend.
    final List<Map<String, dynamic>> groups = [
      {'name': 'Alpha Team', 'score': 1000},
      {'name': 'Beta Squad', 'score': 950},
      // More groups...
    ];

    // Sort the groups by score in descending order
    groups.sort((a, b) => b['score'].compareTo(a['score']));

    return Scaffold(
      appBar: AppBar(
          title: const Text('SQUAD LEADERBOARDS',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                // Navigate to the screen for creating a new group
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateGroupScreen()),
                );
              },
            ),
          ],
          backgroundColor: Colors.red[400],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Leaderboards()),
                );
              })),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return Card(
            margin: const EdgeInsets.all(16.0),
            child: ListTile(
              title: Text(group['name']),
              subtitle: Text('Routes Completed: ${group['score']}'),
              onTap: () {
                // TODO: Navigate to the detail page for this group.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupDetailScreen(group: group),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class GroupDetailScreen extends StatelessWidget {
  final Map<String, dynamic> group;

  const GroupDetailScreen({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Retrieve the list of users and their routes completed for this group from Firebase
    final List<Map<String, dynamic>> users = [
      // Placeholder data, replace with actual data from Firebase
      {'name': 'User A', 'routes': 40},
      {'name': 'User B', 'routes': 39},
      // More users...
    ];

    // Sort the users by the number of routes completed in descending order
    users.sort((a, b) => b['routes'].compareTo(a['routes']));

    return Scaffold(
      appBar: AppBar(
        title: Text(group['name']),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user['name']),
            trailing: Text('${user['routes']}'),
          );
        },
      ),
    );
  }
}

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Squad'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
                hintText: 'Enter your group name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Use the group name from _groupNameController.text to create a new group in the backend.
                // TODO: Generate a random 6-letter code for the new group.
                // TODO: Store the new group in the backend with the generated code.
              },
              child: const Text('Create Squad Group'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }
}
