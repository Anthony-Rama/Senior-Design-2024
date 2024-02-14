import 'package:flutter/material.dart';
import 'package:mobileapp/main.dart';
import 'package:mobileapp/Screens/home_screen.dart';
import 'package:mobileapp/Screens/custom_routes.dart';
import 'package:mobileapp/Screens/stats.dart';
import 'package:mobileapp/Screens/leaderboards.dart';

class ListItem {
  final String title;
  String selectedOption;
  final List<String> dropdownOptions;

  ListItem({
    required this.title,
    required this.selectedOption,
    required this.dropdownOptions,
  });
}

void main() {
  runApp(const MyApp());
}

class PresetScreen extends StatelessWidget {
  PresetScreen({super.key});

  // key to access Scaffold state (for side menu navigation)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<ListItem> listItems = [
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
    ];

    return MaterialApp(
      home: Scaffold(
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
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 123,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                  ),
                  child: Center(
                    child: Text(
                      'MENU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('Custom Routes'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomRoutes(),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('Stats'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Stats()),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('Leaderboards'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Leaderboards()),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const HomeScreen(), //TODO: change to settings screen
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: listItems.length,
          itemBuilder: (BuildContext context, int index) {
            return DropdownListItem(listItem: listItems[index]);
          },
        ),
      ),
    );
  }
}

class DropdownListItem extends StatefulWidget {
  final ListItem listItem;

  const DropdownListItem({Key? key, required this.listItem}) : super(key: key);

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
}
