import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:mobileapp/Screens/preset.dart';

class PresetDisplayScreen extends StatefulWidget {
  final PresetRoute route;

  const PresetDisplayScreen({Key? key, required this.route}) : super(key: key);

  @override
  _PresetDisplayScreenState createState() => _PresetDisplayScreenState();
}

class _PresetDisplayScreenState extends State<PresetDisplayScreen> {
  List<List<bool>> gridState = List.generate(9, (_) => List.filled(5, false));

  @override
  void initState() {
    super.initState();
    _updateGridState(
        widget.route.holds); // Update grid state with holds from route
  }

  void _updateGridState(List<int> holds) {
    // Reset grid state
    for (int i = 0; i < gridState.length; i++) {
      for (int j = 0; j < gridState[i].length; j++) {
        gridState[i][j] = false;
      }
    }

    // Set holds in grid state
    for (int holdIndex in holds) {
      int rowIndex = 8 - (holdIndex ~/ 5);
      int colIndex = holdIndex % 5;
      gridState[rowIndex][colIndex] = true;
    }
    setState(() {});
  }

  Future<void> _updateCompletedRoutes() async {
    try {
      // Get current user's ID using FirebaseAuth
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final currentUserID = currentUser.uid;

        // Retrieve user document from Firestore
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(currentUserID);

        // Check if completedRoutes field exists
        final userSnapshot = await userDoc.get();
        int completedRoutes = 1;
        if (userSnapshot.exists) {
          final userData = userSnapshot.data() as Map<String, dynamic>?;
          if (userData != null && userData.containsKey('completedRoutes')) {
            completedRoutes = userData['completedRoutes'] + 1;
          }
        }

        // Update user document with completedRoutes field
        await userDoc
            .set({'completedRoutes': completedRoutes}, SetOptions(merge: true));
      } else {
        print('User not authenticated.');
      }
    } catch (error) {
      print('Error updating completedRoutes: $error');
    }
  }

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
        child: _buildGridSystem(),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 40,
            child: FloatingActionButton(
              onPressed: () {
                // Add your action for the left button
                _updateCompletedRoutes();
              },
              mini: true,
              child: Icon(Icons.check),
            ),
          ),
          SizedBox(width: 16), // Add some space between the buttons
          SizedBox(
            width: 40,
            child: FloatingActionButton(
              onPressed: () {
                // Add your action for the right button
              },
              mini: true,
              child: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridSystem() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 1.8, // image width
      height: size.width * 1.8, // image height
      child: Stack(
        children: [
          Image.asset(
            'assets/climbing_board.jpeg', // Change this to the appropriate image for preset routes
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(3.0, 28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  gridState.length,
                  (rowIndex) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      gridState[rowIndex].length,
                      (colIndex) => GestureDetector(
                        onTap: () {
                          setState(() {
                            gridState[rowIndex][colIndex] =
                                !gridState[rowIndex][colIndex];
                          });
                        },
                        child: Container(
                          width: size.width * 0.09,
                          height: size.width * 0.09,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 22.6,
                            vertical: 11.5,
                          ),
                          decoration: BoxDecoration(
                            color: gridState[rowIndex][colIndex]
                                ? Colors.blue
                                : Colors.transparent,
                            border: Border.all(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
