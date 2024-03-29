import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingList extends StatelessWidget {
  final String uid;

  const FollowingList({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text("No data available"));
          }

          DocumentSnapshot userDoc = snapshot.data!;
          List<dynamic> followingIds = userDoc['following'];

          if (followingIds.isEmpty) {
            return Center(child: Text("You're not following anyone yet."));
          }

          return ListView.builder(
            itemCount: followingIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(followingIds[index])
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListTile(
                      leading: CircleAvatar(),
                      title: Text("Loading..."),
                    );
                  }

                  DocumentSnapshot followingUserDoc = snapshot.data!;
                  return ListTile(
                    leading: CircleAvatar(
                        // If you have a profile image URL, you can use NetworkImage
                        // backgroundImage: NetworkImage(
                        // followingUserDoc['profileImageUrl'] ?? ''),
                        ),
                    title: Text(followingUserDoc['name'] ?? 'No Name'),
                    // Optionally, navigate to the user profile or perform other actions when tapped
                    onTap: () => {},
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
