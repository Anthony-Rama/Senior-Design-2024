import 'package:flutter/material.dart';
import 'package:mobileapp/platforms/sidemenu.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

BluetoothDevice? thedevice;

class BoardConnect extends StatefulWidget {
  const BoardConnect({super.key});

  @override
  _BoardConnectState createState() => _BoardConnectState();
}

class _BoardConnectState extends State<BoardConnect> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    Future<void> scandevice() async {
      try {
        await FlutterBluePlus.startScan();
        FlutterBluePlus.scanResults.listen((results) {
          if (results.isNotEmpty) {
            debugPrint("device ${results.last.device.advName}");
            if (results.last.device.advName == "BellTest") {
              debugPrint("adding belltest looking like ${results.last.device}");
              thedevice = results.last.device;
              debugPrint("successfully added ${(thedevice?.platformName)!}");
              FlutterBluePlus
                  .stopScan(); // Stop scanning after finding the device
            }
          }
        });
      } catch (e) {
        debugPrint("Error scanning devices: $e");
      }
    }

    Future<void> connectdevice() async {
      try {
        if (thedevice != null) {
          debugPrint("Attempting connect to ${(thedevice?.platformName)!}");
          await thedevice!.connect(autoConnect: false);
          debugPrint("Connected to ${(thedevice?.platformName)!}");
        } else {
          debugPrint("No device to connect to.");
        }
      } catch (e) {
        debugPrint("Error connecting to device: $e");
      }
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
