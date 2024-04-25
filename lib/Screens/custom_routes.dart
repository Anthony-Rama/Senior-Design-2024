import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/Screens/route_display.dart';
import 'package:mobileapp/platforms/sidemenu.dart';
import 'package:mobileapp/Screens/route_creation.dart';
import 'package:mobileapp/Screens/route_display.dart';

class CustomRoutes extends StatefulWidget {
  const CustomRoutes({Key? key}) : super(key: key);

  @override
  _CustomRoutesState createState() => _CustomRoutesState();
}

class _CustomRoutesState extends State<CustomRoutes> {
  late Future<List<Map<String, dynamic>>> _customRoutesFuture;

  @override
  void initState() {
    super.initState();
    _customRoutesFuture = _fetchCustomRoutes();
  }

  Future<List<Map<String, dynamic>>> _fetchCustomRoutes() async {
    QuerySnapshot routeSnapshot =
        await FirebaseFirestore.instance.collection('routes').get();

    List<Map<String, dynamic>> customRoutes = [];

    for (var doc in routeSnapshot.docs) {
      String routeName = doc['routeName'];
      String userId = doc['userId'];

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      String username = userSnapshot['username'];

      customRoutes.add({'routeName': routeName, 'username': username});
    }

    return customRoutes;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'CUSTOM ROUTES',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomRouteGridScreen(),
            ),
          );
        },
        backgroundColor: Colors.red[400],
        child: const Icon(Icons.add, color: Colors.white),
      ), //
      drawer: const sideMenu(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _customRoutesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final routeName = snapshot.data![index]['routeName'];
                final username = snapshot.data![index]['username'];
                return ListTile(
                  title: Text('$routeName by $username'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayRouteScreen(
                          routeName: routeName,
                          username: username,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
