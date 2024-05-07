import 'package:flutter/material.dart';
import 'package:mobileapp/platforms/sidemenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  List<Map<String, String>> completedRouteNames = [];

  @override
  void initState() {
    super.initState();
    _fetchCompletedRoutes();
  }

  Future<void> _fetchCompletedRoutes() async {
    try {
      // Get current user's ID using FirebaseAuth
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final currentUserID = currentUser.uid;

        // Retrieve completed routes for the current user from Firestore
        final querySnapshot = await FirebaseFirestore.instance
            .collection('completedroutes')
            .doc(currentUserID)
            .get();

        // Check if the document exists
        if (querySnapshot.exists) {
          final data = querySnapshot.data();
          if (data != null && data.containsKey('completedRouteNames')) {
            //final List<dynamic> routeNamesData = data['completedRouteNames'];
            // Convert each route to a Map<String, String> and add it to completedRoutes
            //routes.forEach((route) {
              //final routeData = route as Map<String, dynamic>;
              //final routeName = routeData['routeName'] ?? '';
              //final date = routeData['date'] ?? '';
              //final time = routeData['time'] ?? '';
              //completedRoutes.add({'routeName': routeName});
              final routeNames = List<String>.from(data['completedRouteNames']);
               completedRouteNames =
                routeNames.map((routeName) => {'routeName': routeName}).toList();
            //});
          }
        }
      } else {
        print('User not authenticated.');
      }
      setState(() {});
    } catch (error) {
      print('Error fetching completed routes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'COMPLETED ROUTES',
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
      body: completedRouteNames.isEmpty
        ? const Center(
            child: Text(
              'No completed routes found.',
              style: TextStyle(fontSize: 18.0),
            ),
          )
      
      :ListView.builder(
        itemCount: completedRouteNames.length,
        itemBuilder: (context, index) {
          //if (index == 0) {
          final routeName = completedRouteNames[index];
          return ListTile(
            title: Text(
              routeName['routeName']!,
              style: const TextStyle(color: Colors.black),
              /* children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Route Name',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                 /* Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Date',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Time',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),*/
                ],
              ),
            );
          } else {
            final route = completedRoutes[index - 1];
            return ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        route['routeName'] ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        route['date'] ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        route['time'] ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),*/
              //],
            ),
          );
          //}
        },
      ),
      drawer: const sideMenu(),
    );
  }
}
