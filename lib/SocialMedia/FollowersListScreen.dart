import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowersList extends StatelessWidget {
  final String uid;
  const FollowersList({Key? key, required this.uid}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FOLLOWERS',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            //.collection('followers')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          //if (snapshot.hasError) {
          //return Center(child: Text('Error: ${snapshot.error}'));
          //}
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No data available."));
          }

          List<dynamic>? followers = snapshot.data!.get('followers');
          if (followers == null || followers.isEmpty) {
            return Center(child: Text("No followers yet."));
          }
          //DocumentSnapshot userDoc = snapshot.data!;
          //List<dynamic> followersIds = userDoc.get('followers');
          //if (!snapshot.hasData) return const CircularProgressIndicator();
          //var followers = snapshot.data!.docs;
          return ListView.builder(
            itemCount: followers.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                .collection('users')
                .doc(followers[index])
                .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: CircleAvatar(),
                      title: Text("Loading...")
                    );
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return ListTile(
                      leading: CircleAvatar(),
                      title: Text("User not found"),
                    );
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return ListTile(
                      leading: CircleAvatar(),
                      title: Text("User not found"),
                    );
                  }
                  var followerData = snapshot.data!.data() as Map<String, dynamic>;
                  return ListTile(
                    leading: CircleAvatar(
                     backgroundImage: NetworkImage(followerData['profilePic'] ?? ''), 
                    ),
                    title: Text(followerData['username'] ?? 'No Username'),
                  );
                }
              );
              //var followerData =
                  //followersIds[index].data() as Map<String, dynamic>;
              // final profilePic = followerData['profilePic'];
              //final username = followerData['username'];
              //if (profilePic == null || username == null) {
              //return ListTile(
              //title:
              //  Text('Error: Missing data for follower at index $index'),
              //);
              //}
              //return ListTile(
                //leading: CircleAvatar(
                  //backgroundImage: NetworkImage(followerData['profilePic']),
                //),
                //title: Text(followerData['username'] ?? ''),
              //);
            },
          );
        },
      ),
    );
  }
}
