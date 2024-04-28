import 'package:flutter/material.dart';
import 'package:mobileapp/platforms/sidemenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'preset_display.dart';

class PresetRoute {
  final String id;
  final String name;
  final String difficulty;

  PresetRoute({
    required this.id,
    required this.name,
    required this.difficulty,
  });
}

class PresetScreen extends StatelessWidget {
  PresetScreen({super.key});

  // key to access Scaffold state (for side menu navigation)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    /*List<ListItem> listItems = [
      ListItem(
        title: 'Beginner',
        selectedOption: 'Option 1',
        dropdownOptions: ['Option 1', 'Option 2', 'Option 3'],
      ),
      ListItem(
        title: 'Intermediate',
        selectedOption: 'Option 1',
        dropdownOptions: ['Option 1', 'Option 2', 'Option 3'],
      ),
      ListItem(
          title: 'Expert',
          selectedOption: 'Option 1',
          dropdownOptions: ['Option 1', 'Option 2', 'Option 3'])
    ];*/

    //return MaterialApp(
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
              // open drawer using key
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        body: FutureBuilder<List<PresetRoute>>(
        future: fetchPresetRoutes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No preset routes available.'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final presetRoute = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to preview screen when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PresetDisplayScreen(route: presetRoute),
                      ),
                    );
                  },
                  child: GridTile(
                    child: Container(
                      color: Colors.blue, // Example color
                      child: Center(
                        child: Text(presetRoute.name),
                      ),
        //drawer: const sideMenu(),
        //body: ListView.builder(
          //itemCount: listItems.length,
          //itemBuilder: (BuildContext context, int index) {
            //return DropdownListItem(listItem: listItems[index]);
          //},
        ),
      ),
    );
  },
);
          }
        },
        ),
      drawer: const sideMenu(),
      );
  }
Future<List<PresetRoute>> fetchPresetRoutes() async {
    try {
      // Fetch preset routes from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('presets').get();

      // Convert Firestore data to PresetRoute objects
      List<PresetRoute> presetRoutes = querySnapshot.docs.map((doc) {
        return PresetRoute(
          id: doc.id,
          name: doc['name'],
          difficulty: doc['difficulty'],
        );
      }).toList();

      return presetRoutes;
    } catch (e) {
      print('Error fetching preset routes: $e');
      return []; // Return empty list if error occurs
    }
  }
}





/*class DropdownListItem extends StatefulWidget {
  final ListItem listItem;

  const DropdownListItem({super.key, required this.listItem});

  @override
  _DropdownListItemState createState() => _DropdownListItemState();
}

class _DropdownListItemState extends State<DropdownListItem> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.listItem.title,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red[400]),
      ),
      children: widget.listItem.dropdownOptions.map((option) {
        return ListTile(
          title: Text(option),
          onTap: () {
            setState(() {
              widget.listItem.selectedOption = option;
            });
          },
        );
      }).toList(),
    );
  }
}*/
