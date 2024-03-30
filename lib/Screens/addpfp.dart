import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileapp/SocialMedia/feed.dart'; // Make sure this import is correct

class AddPFPScreen extends StatefulWidget {
  const AddPFPScreen({super.key});

  @override
  _AddPFPScreenState createState() => _AddPFPScreenState();
}

class _AddPFPScreenState extends State<AddPFPScreen> {
  File? _image;

  Future<void> uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No image selected.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${FirebaseAuth.instance.currentUser!.uid}');
      await storageRef.putFile(_image!);
      final String imageURL = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'profilePic': imageURL});

      // Navigate to Feed Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FeedScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload image. Please try again. $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> skipImage() async {
    // No need to update if skipping
    // Navigate directly to Feed Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FeedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD PROFILE PICTURE',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[400],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 70,
                    backgroundImage: FileImage(_image!),
                  )
                : const CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1024px-Default_pfp.svg.png'),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadImage,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
              child: const Text('Upload & Continue',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: skipImage,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
              child: const Text('Skip', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
