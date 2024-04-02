import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingList extends StatelessWidget {
  final String uid;

  const FollowingList({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FOLLOWING',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }

          DocumentSnapshot userDoc = snapshot.data!;
          List<dynamic> followingIds = userDoc.get('following');

          if (followingIds.isEmpty) {
            return const Center(
                child: Text("You're not following anyone yet."));
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
                    return const ListTile(
                      leading: CircleAvatar(),
                      title: Text("Loading..."),
                    );
                  }

                  DocumentSnapshot followingUserDoc = snapshot.data!;
                  String? profilePicUrl =
                      followingUserDoc['profilePic'] as String?;
                  return ListTile(
                    leading: CircleAvatar(
                      // If you have a profile image URL, you can use NetworkImage
                      backgroundImage:
                          profilePicUrl != null ? 
                          NetworkImage(profilePicUrl) : null,
                    ),
                    title: Text(followingUserDoc['username'] ?? 'No Name'),
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
