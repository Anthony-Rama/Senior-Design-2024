import 'package:flutter/material.dart';
import 'package:mobileapp/platforms/sidemenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'preset_display.dart';

class PresetRoute {
  final String id;
  final String name;
  final String difficulty;
  final List<int> holds; // Add holds list here

  PresetRoute({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.holds, // Update constructor to include holds
  });
}

class PresetScreen extends StatelessWidget {
  PresetScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'PRESET ROUTES',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchPresetDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No preset routes available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final document = snapshot.data![index];
                return DropdownTile(document: document);
              },
            );
          }
        },
      ),
      drawer: const sideMenu(),
    );
  }

  Future<List<DocumentSnapshot>> fetchPresetDocuments() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('presets').get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching preset documents: $e');
      return [];
    }
  }
}

class DropdownTile extends StatelessWidget {
  final DocumentSnapshot document;

  const DropdownTile({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        document.id.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red[400]),
      ),
      children: [
        ...List.generate(
          3,
          (index) {
            final fieldName = '${document.id}${index + 1}';
            final holdsArray = List<int>.from(document[fieldName] ?? []);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    fieldName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PresetDisplayScreen(
                          route: PresetRoute(
                            id: '$index',
                            name: fieldName,
                            difficulty: document.id,
                            holds: holdsArray, // Populate holds with the array
                          ),
                        ),
                      ),
                    );
                  },
                  //child: Text(fieldName),
                ),
                Divider(),
              ],
            );
          },
        ),
      ],
    );
  }
}
