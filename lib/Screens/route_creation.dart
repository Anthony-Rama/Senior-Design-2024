import 'package:flutter/material.dart';

class CustomRouteGridScreen extends StatefulWidget {
  @override
  _CustomRouteGridScreenState createState() => _CustomRouteGridScreenState();
}

class _CustomRouteGridScreenState extends State<CustomRouteGridScreen> {
  List<List<bool>> gridState = List.generate(16, (_) => List.filled(8, false));

  // holds coordinates on the climbing board image relative to the image size
  List<List<Offset>> holdCoordinates =
      List.generate(16, (_) => List.filled(8, Offset.zero));

  @override
  void initState() {
    super.initState();
    holdCoordinates = List.generate(16, (i) {
      return List.generate(8, (j) {
        return Offset(20 + j * 60, 20 + i * 40); // values can be adjuste here
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
                width: size.width * 2.0, // image width
                height: size.width * 2.0, // image height
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/climbing_board.jpeg',
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
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
                                      horizontal: 7.2,
                                      vertical: 3),
                                  decoration: BoxDecoration(
                                    color: gridState[rowIndex][colIndex]
                                        ? Colors.blue
                                        : Colors.transparent,
                                    border: Border.all(color: Colors.black),
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
          List<Offset> selectedHolds = [];
          for (int i = 0; i < gridState.length; i++) {
            for (int j = 0; j < gridState[i].length; j++) {
              if (gridState[i][j]) {
                selectedHolds.add(holdCoordinates[i][j]);
              }
            }
          }
          // print holds list
          print('Selected Holds: $selectedHolds');
        },
        backgroundColor: Colors.red[400],
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}
