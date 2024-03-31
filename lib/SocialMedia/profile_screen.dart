import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileapp/Screens/settings.dart';
import 'package:mobileapp/SocialMedia/FollowersListScreen.dart';
import 'package:mobileapp/SocialMedia/FollowingListScreen.dart';
import 'package:mobileapp/backend_resources/firestore_methods.dart';
// Create this
import 'package:mobileapp/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
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

  Future<void> changeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      try {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'profile_pictures/${FirebaseAuth.instance.currentUser!.uid}');
        await storageRef.putFile(image);

        // Get the updated download URL
        final String imageURL = await storageRef.getDownloadURL();

        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null && mounted) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .update({'profilePic': imageURL});

          setState(() {
            userData['profilePic'] = imageURL;
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to update profile picture. Please try again.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOwnProfile =
        FirebaseAuth.instance.currentUser!.uid == widget.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(userData['username'] ?? 'Profile'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(userData['profilePic']),
                      ),
                      Positioned(
                        child: IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          onPressed: changeImage,
                        ),
                        // bottom: -10,
                        // left: 80,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStatColumn(postLen, 'posts'),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        FollowersList(uid: widget.uid))),
                            child: buildStatColumn(followers, 'followers'),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        FollowingList(uid: widget.uid))),
                            child: buildStatColumn(following, 'following'),
                          ),
                        ],
                      ),
                      isOwnProfile
                          ? FollowButton(
                              text: 'Edit Profile',
                              backgroundColor: Colors.grey[200]!,
                              textColor: Colors.black,
                              borderColor: Colors.grey,
                              function: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const SettingsScreen())),
                            )
                          : FollowButton(
                              text: isFollowing ? 'Unfollow' : 'Follow',
                              backgroundColor:
                                  isFollowing ? Colors.white : Colors.blue,
                              textColor:
                                  isFollowing ? Colors.black : Colors.white,
                              borderColor: Colors.grey,
                              function: handleFollowUnfollow,
                            ),
                    ],
                  ),
                ),
                const Divider(),
                buildPostGrid(),
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

  Widget buildPostGrid() {
    // FutureBuilder for fetching posts
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var docs = snapshot.data!.docs;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return Image.network(docs[index]['postUrl'], fit: BoxFit.cover);
          },
        );
      },
    );
  }
}
