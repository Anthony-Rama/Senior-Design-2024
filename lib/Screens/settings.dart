import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/home_screen.dart';
import 'package:mobileapp/Screens/login.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //title: 'FLUTTER DEMO',
      //theme: ThemeData(
        //primarySwatch: Colors.blue,
      //),
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red[400],
        leading: IconButton(
          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()),);},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
              Text('Account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 239, 83, 80)))
            ],
          ),
          const Divider(height: 20, thickness: 1),
          const SizedBox(height: 20),
          buildAccountOption(context, 'Change Password'),
          const SizedBox(height: 10),
          buildAccountOption(context, 'Change email'),
          const SizedBox(height: 10),
          buildAccountOption(context, 'First Name'),
          const SizedBox(height: 10),
          buildAccountOption(context, 'Last Name')

        ],
       ), 
      ),
      bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        color: Colors.red[400],
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        ), 
        child: const Text('Log out'), 
    ),
   ),
  );
 }
}

GestureDetector buildAccountOption(BuildContext context, String title) {
  return GestureDetector(
    onTap: () {
      showDialog(context: context, builder: (BuildContext conext){
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color:Color.fromARGB(255, 239, 83, 80)))
            )
          ]
        );
      });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey
          ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey)
        ],
      ),
    ),
  );
}