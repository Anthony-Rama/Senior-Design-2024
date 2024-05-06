import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'board_connection.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomRouteGridScreen extends StatefulWidget {
  const CustomRouteGridScreen({super.key});

  @override
  _CustomRouteGridScreenState createState() => _CustomRouteGridScreenState();
}

class _CustomRouteGridScreenState extends State<CustomRouteGridScreen> {
  List<List<bool>> gridState = List.generate(9, (_) => List.filled(5, false));

  // holds coordinates on the climbing board image relative to the image size
  List<List<Offset>> holdCoordinates =
      List.generate(9, (_) => List.filled(5, Offset.zero));

  final TextEditingController _routeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    holdCoordinates = List.generate(9, (i) {
      return List.generate(5, (j) {
        return Offset(20 + j * 60, 20 + i * 40); // values can be adjusted here
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CREATE CUSTOM ROUTE',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 1.8, // image width
                height: size.width * 1.8, // image height
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/climbing_board.jpeg',
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: Transform.translate(
                        offset: const Offset(3.0, 28.0),
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
                                    // adjust hold size
                                    width: size.width * 0.09,
                                    height: size.width * 0.09,
                                    margin: const EdgeInsets.symmetric(
                                      // adjust space between rows and columns
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await _showNameRouteDialog();
            },
            backgroundColor: Colors.red[400],
            child: const Icon(Icons.save, color: Colors.white),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              await _sendRouteToBluetooth();
            },
            backgroundColor: Colors.red[400],
            child: const Icon(Icons.bluetooth, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _showNameRouteDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Name Your Route'),
          content: TextFormField(
            controller: _routeNameController,
            decoration: const InputDecoration(
              labelText: 'Route Name',
              hintText: 'Enter a name for your route',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await saveRouteToFirestore(
                    _routeNameController.text, _getSelectedHolds());
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendRouteToBluetooth() async {
    List<int> selectedHolds = _getSelectedHolds();
    // Assuming you have an instance of FlutterBlue
    // and thedevice variable correctly set up
    if (thedevice?.isConnected ?? false) {
      debugPrint("attempting write to ${(thedevice?.advName.toString())!}");
      debugPrint("and it looks like this ${thedevice!}");
      Uint8List bytearray = Uint8List.fromList(selectedHolds);
      List<BluetoothService> services = await thedevice!.discoverServices();
      for (BluetoothService service in services) {
        print("report service ${service.uuid}");
        if (service.uuid.toString() == "5c5bfdde-78e6-40e8-a009-831a927be6cc") {
          service.characteristics.first.write(bytearray);
          print("done writing");
        }
      }
    } else {
      print("no device to write to, placeholder error");
    }
  }

  Future<void> saveRouteToFirestore(
      String routeName, List<int> selectedHolds) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        String routeId = firestore.collection('routes').doc().id;

        DocumentSnapshot userSnapshot =
            await firestore.collection('users').doc(user.uid).get();
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        String? username = userData?['username'];

        // route model
        Map<String, dynamic> routeData = {
          'userId': user.uid,
          'username': username,
          'routeName': routeName,
          'holds': selectedHolds,
        };

        await firestore.collection('routes').doc(routeId).set(routeData);

        print('Route saved to Firestore with ID: $routeId');
      } else {
        print('User is not authenticated.');
      }
    } catch (e) {
      print('Error saving route: $e');
    }
  }

  List<int> _getSelectedHolds() {
    List<int> selectedHolds = [];
    for (int i = 0; i < gridState.length; i++) {
      for (int j = 0; j < gridState[i].length; j++) {
        if (gridState[i][j]) {
          int index;
          if (i % 2 == 0) {
            // left to right if it is even row
            index = (8 - i) * gridState[i].length + j;
          } else {
            // right to left if it is odd row
            index =
                (8 - i) * gridState[i].length + (gridState[i].length - 1 - j);
          }
          selectedHolds.add(index);
        }
      }
    }
    print('Selected Holds: $selectedHolds');
    return selectedHolds;
  }
}
