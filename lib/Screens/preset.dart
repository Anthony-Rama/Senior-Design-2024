import 'package:flutter/material.dart';
import 'package:mobileapp/Screens/home_screen.dart';
import 'package:mobileapp/main.dart';

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
  const PresetScreen({super.key});
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
        appBar: AppBar(
            title: const Text(
              'PRESET ROUTES',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red[400],
           leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()),);
                  //Navigator.of(context).pop();
                })),
        //),
        //backgroundColor: Colors.red[400],
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
  // ignore: library_private_types_in_public_api
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
