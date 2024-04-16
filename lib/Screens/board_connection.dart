import 'package:flutter/material.dart';
import 'package:mobileapp/platforms/sidemenu.dart';
import 'package:mobileapp/Screens/route_creation.dart';

class BoardConnect extends StatefulWidget {
  const BoardConnect({Key? key}) : super(key: key);

  @override
  _BoardConnectState createState() => _BoardConnectState();
}

class _BoardConnectState extends State<BoardConnect> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'BOARD CONNECTION',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                //ANDREW WORK HERE
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
              child: const Text('Connect to BellBoard',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      drawer: const sideMenu(),
    );
  }
}
