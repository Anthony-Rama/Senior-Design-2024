import 'package:flutter/material.dart';
import 'package:mobileapp/platforms/sidemenu.dart';
import 'package:mobileapp/Screens/route_creation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

BluetoothDevice? thedevice;

class BoardConnect extends StatefulWidget {
  const BoardConnect({Key? key}) : super(key: key);

  @override
  _BoardConnectState createState() => _BoardConnectState();
}

class _BoardConnectState extends State<BoardConnect> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    scandevice() async {
      FlutterBluePlus.startScan();
      FlutterBluePlus.scanResults.listen((results) {
        if (results.last.advertisementData.serviceUuids.first.str ==
            "5c5bfdde-78e6-40e8-a009-831a927be6cc") {
          thedevice = results.last.device;
        }
      });
    }

    connectdevice() async {
      print("Attempting connect to " + (thedevice?.platformName)!);
      thedevice?.connect(autoConnect: false, timeout: Duration(seconds: 25));
    }

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
                if (thedevice == null) {
                  scandevice();
                }
                if (thedevice != null) {
                  connectdevice();
                }
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
