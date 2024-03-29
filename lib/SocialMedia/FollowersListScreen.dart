import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowersList extends StatelessWidget {
  final String uid;
  const FollowersList({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('followers')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var followers = snapshot.data!.docs;
          return ListView.builder(
            itemCount: followers.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(followers[index]
                    ['name']), // Make sure your user document has 'name' field
              );
            },
          );
        },
      ),
    );
  }
}
