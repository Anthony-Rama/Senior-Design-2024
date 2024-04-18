import 'package:flutter/material.dart';
import 'package:mobileapp/platforms/sidemenu.dart';
import 'package:mobileapp/Screens/route_creation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'dart:developer';

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

    Future<void> scandevice() async {
      await FlutterBluePlus.startScan();
      var resultvar = FlutterBluePlus.scanResults.listen((results) {
        debugPrint("device " + results.last.device.advName);
        if (results.isNotEmpty) {
          if (results.last.device.advName == "BellTest") {
            thedevice = results.last.device;
            debugPrint("successfully added " + (thedevice?.platformName)!);
          }
        }
      });
    }

    connectdevice() async {
      debugPrint("Attempting connect to " + (thedevice?.platformName)!);
      await thedevice?.connect(
          autoConnect: false, timeout: Duration(seconds: 25));
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
              onPressed: () async {
                //ANDREW WORK HERE
                //await FlutterBluePlus.turnOn();
                debugPrint("on pressed enter");
                if (thedevice == null) {
                  debugPrint("scanning devices");
                  await scandevice();
                  //await FlutterBluePlus.stopScan();
                }
                if (thedevice != null) {
                  debugPrint("connecting device");
                  await connectdevice();
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
