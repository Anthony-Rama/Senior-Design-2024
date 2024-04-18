import 'package:flutter/material.dart';
import 'board_connection.dart';

class CustomRouteGridScreen extends StatefulWidget {
  @override
  _CustomRouteGridScreenState createState() => _CustomRouteGridScreenState();
}

class _CustomRouteGridScreenState extends State<CustomRouteGridScreen> {
  List<List<bool>> gridState = List.generate(9, (_) => List.filled(5, false));

  // holds coordinates on the climbing board image relative to the image size
  List<List<Offset>> holdCoordinates =
      List.generate(9, (_) => List.filled(5, Offset.zero));

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
          'Create Custom Route',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
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
                        offset: Offset(3.0, 28.0),
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
                                        vertical: 11.5),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
                  index = (8 - i) * gridState[i].length +
                      (gridState[i].length - 1 - j);
                }
                selectedHolds.add(index);
                thedevice?.servicesList.first.characteristics.first
                    .write(selectedHolds);
              }
            }
          }
          print('Selected Holds: $selectedHolds');
          if (thedevice?.isConnected ?? false) {
            thedevice?.servicesList.first.characteristics.first
                .write(selectedHolds);
          } else {
            print("no device to write to, placeholder error");
          }
        },
        backgroundColor: Colors.red[400],
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}
