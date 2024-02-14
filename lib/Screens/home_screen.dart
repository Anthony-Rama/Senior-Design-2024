import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/login.dart';
import 'package:mobileapp/Screens/preset.dart';
import 'package:mobileapp/Screens/leaderboards.dart';
import 'package:mobileapp/Screens/stats.dart';
import 'package:mobileapp/Screens/custom_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Welcome "Username"'), // TODO: Replace "username" with user.id from Firebase
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout), // Change to a logout icon
          onPressed: () {
            // TODO: Implement user logout logic (clear user session, etc.)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const LoginScreen()), // Navigate to LoginScreen
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Use the minimum space needed by the children
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
                },
                child: const Text(
                  'CONNECT TO BELLBOARD',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PresetScreen()),
                  );
                },
                child: const Text(
                  'PRESET ROUTES',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CustomRoutes()),
                  );
                },
                child: const Text(
                  'CUSTOM ROUTES',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Stats()),
                  );
                },
                child: const Text(
                  'STATS',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Leaderboards()),
                  );
                },
                child: const Text(
                  'LEADERBOARDS',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width:
                  buttonWidth, // Ensure the width is the same for all buttons
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
                  // TODO: Placeholder for navigation or functionality for settings and other screens
                },
                child: const Text(
                  'SETTINGS',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*
--------- Template for adding a button (add underneath '), // SizedBox' ----------- 
// SizedBox is used to give spacing between the widgets. Here, it provides a 20-pixel vertical space.
const SizedBox(height: 20),

// SizedBox is also used to constrain the width of the button to 'buttonWidth', ensuring all buttons have the same width.
SizedBox(
  width: buttonWidth, // This sets the width for the button.
  child: OutlinedButton(
    // OutlinedButton is a type of button that has a border and no elevation (no shadow).
    style: OutlinedButton.styleFrom(
      // styleFrom allows you to customize the button's style.
      foregroundColor: Colors.white, // Sets the text color inside the button.
      backgroundColor: Colors.red[400], // Sets the button's background color.
      side: const BorderSide(color: Colors.red, width: 2), // Defines the border's color and width.
      shape: RoundedRectangleBorder(
        // The shape defines the form of the button; here it's a rectangle with rounded corners.
        borderRadius: BorderRadius.circular(30.0), // Sets how rounded the corners are.
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 32.0, vertical: 16.0), // Adds spacing inside the button around the text.
    ),
    onPressed: () {
      // The onPressed function is called when the button is tapped.
      // TODO: Placeholder for navigation or functionality for preset routes and other screens
    },
    child: const Text(
      'SETTINGS', // This is the text displayed inside the button.
      style: TextStyle(fontSize: 16.0), // TextStyle allows you to customize the appearance of the text.
    ),
  ),
),
*/ 
