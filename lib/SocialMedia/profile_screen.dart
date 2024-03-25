import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileapp/backend_resources/auth_methods.dart';
import 'package:mobileapp/backend_resources/firestore_methods.dart';
import 'package:mobileapp/screens/login.dart';
import 'package:mobileapp/utils/utils.dart';
import 'package:mobileapp/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ignore: unused_field
  Uint8List? _image;
  String? _profilePicURL;
  
  @override
  void initState() {
    super.initState();
    getData();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String fileName = '$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      await FirebaseStorage.instance.ref(fileName).putData(img);

      String downloadURL =
          await FirebaseStorage.instance.ref(fileName).getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profilePic': downloadURL,
      });

      //User? user = FirebaseAuth.instance.currentUser;
      // ignore: deprecated_member_use
      //user?.updateProfile(photoURL: downloadURL);

      setState(() {
        _image = img;
        _profilePicURL = downloadURL;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  /*@override
  void initState() {
    super.initState();
    getData();
  }*/

  Future<void> getData() async {
    setState(() {
      //isLoading = true;
      _profilePicURL = FirebaseAuth.instance.currentUser?.photoURL;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      
      isLoading = false;
      _profilePicURL = userData['profilePic'];
      //_currentUsername = FirebaseAuth.instance.currentUser!.displayName;
      // User? user = FirebaseAuth.instance.currentUser;
      //String? profilePicURL = user?.photoURL;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    //setState(() {
    // isLoading = false;
    //_profilePicURL = userSnap.data()?['profilePic'];
    //});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(userData['username'] ?? ''),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _profilePicURL != null
                          ? CircleAvatar(
                              radius: 65,
                              backgroundImage: NetworkImage(_profilePicURL!))
                          : CircleAvatar(
                              radius: 65,
                              backgroundImage: NetworkImage(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1024px-Default_pfp.svg.png'),
                            ),
                      Positioned(
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: selectImage,
                        ),
                        // bottom: -10,
                        // left: 80,
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStatColumn(postLen, "posts"),
                          buildStatColumn(followers, "followers"),
                          buildStatColumn(following, "following"),
                        ],
                      ),
                      FirebaseAuth.instance.currentUser!.uid == widget.uid
                          ? FollowButton(
                              text: 'Sign Out',
                              backgroundColor: Color.fromARGB(255, 239, 83, 80),
                              textColor: Colors.white,
                              borderColor: Colors.grey,
                              function: () async {
                                await AuthMethods().signOut();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                            )
                          : isFollowing
                              ? FollowButton(
                                  text: 'Unfollow',
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  borderColor: Colors.grey,
                                  function: () async {
                                    await FireStoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        userData['uid']);
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
                                        userData['uid']);
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
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
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
