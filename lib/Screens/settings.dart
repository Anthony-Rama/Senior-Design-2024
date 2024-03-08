import 'package:flutter/material.dart';
import 'package:mobileapp/platforms/sidemenu.dart';

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
            buildAccountOption(context, 'Change Username'),
            const SizedBox(height: 10),
            buildAccountOption(context, 'Change email'),
            const SizedBox(height: 10),
            buildAccountOption(context, 'Change Password'),
            const SizedBox(height: 10),
            buildAccountOption(context, 'Change First Name'),
            const SizedBox(height: 10),
            buildAccountOption(context, 'Change Last Name')
          ],
        ),
      ),
      drawer: const sideMenu(),
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
