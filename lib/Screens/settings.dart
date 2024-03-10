import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/platforms/sidemenu.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

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
            buildAccountOption(context, 'Change Username'),
            const SizedBox(height: 10),
            buildAccountOption(context, 'Change First Name'),
            const SizedBox(height: 10),
            buildAccountOption(context, 'Change Last Name'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      //title : const Text('Change Email'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'To change your email, logout and click "Reset Email here!"',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close',
                              style: TextStyle(color: Colors.red[400])),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Change Email',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey)
                  ],
                ),
              ),
            ),

            //buildAccountOption(context, 'Change Email'),
            const SizedBox(height: 10),
            //buildAccountOption(context, 'Change Password')
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      //title : const Text('Change Email'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'To change your password, logout and click "Forgot password?"',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close',
                              style: TextStyle(color: Colors.red[400])),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Change Password',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const sideMenu(),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(labelText: 'New'),
                  ),
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
                      child: const Text(
                        'Close',
                        style:
                            TextStyle(color: Color.fromARGB(255, 239, 83, 80)),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        String newInfo = _textEditingController.text.trim();
                        String errorMessage = await updateInfo(title, newInfo);
                        if (errorMessage.isEmpty) {
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Save',
                        style:
                            TextStyle(color: Color.fromARGB(255, 239, 83, 80)),
                      ),
                    )
                  ],
                )
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  Future<String> updateInfo(String title, String newInfo) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return 'User not authenticated.';
      }

      // Update user data in Firestore
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      switch (title) {
        case 'Change Username':
          QuerySnapshot usernameSnapshot =
              await users.where('username', isEqualTo: newInfo).get();
          if (usernameSnapshot.docs.isNotEmpty) {
            return 'Username already exists.';
          }
          await users.doc(user.uid).update({'username': newInfo});
          break;
        case 'Change First Name':
          await users.doc(user.uid).update({'firstName': newInfo});
          break;
        case 'Change Last Name':
          await users.doc(user.uid).update({'lastName': newInfo});
          break;
        default:
          break;
      }
      return ''; // No error
    } catch (e) {
      print('Error updating user information: $e');
      return 'Error updating user information.';
    }
  }
}
