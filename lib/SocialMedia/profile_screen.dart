import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/backend_resources/firestore_methods.dart';
import 'package:mobileapp/screens/login.dart';
import 'package:mobileapp/utils/utils.dart';
import 'package:mobileapp/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDataAndPosts();
  }

  void fetchUserDataAndPosts() async {
    setState(() => isLoading = true);
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      if (userSnap.exists) {
        userData = userSnap.data()!;
        followers = List.from(userData['followers'] ?? []).length;
        following = List.from(userData['following'] ?? []).length;
        isFollowing = List.from(userData['followers'] ?? [])
            .contains(FirebaseAuth.instance.currentUser!.uid);
      }
      postLen = postSnap.docs.length;
    } finally {
      setState(() => isLoading = false);
    }
  }

  void handleFollowUnfollow() async {
    setState(() => isLoading = true);
    if (isFollowing) {
      await FireStoreMethods()
          .unfollowUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
    } else {
      await FireStoreMethods()
          .followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
    }
    fetchUserDataAndPosts(); // Refresh data
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(userData['username'] ?? 'Profile'),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStatColumn(postLen, 'posts'),
                          buildStatColumn(followers, 'followers'),
                          buildStatColumn(following, 'following'),
                        ],
                      ),
                      isFollowing
                          ? FollowButton(
                              text: 'Unfollow',
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              borderColor: Colors.grey,
                              function: () async {
                                await FireStoreMethods().unfollowUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.uid);
                                setState(() {
                                  isFollowing = false;
                                  followers--;
                                });
                              },
                            )
                          : FollowButton(
                              text: 'Follow',
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              borderColor: Colors.blue,
                              function: () async {
                                await FireStoreMethods().followUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.uid);
                                setState(() {
                                  isFollowing = true;
                                  followers++;
                                });
                              },
                            ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                        return Image.network(snap['postUrl'],
                            fit: BoxFit.cover);
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
