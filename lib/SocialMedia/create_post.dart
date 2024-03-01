import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final String timestamp;
  final String bodies;
  final String? imageUrl;
  final String? videoUrl;

  Post({
    required this.title,
    required this.timestamp,
    required this.bodies,
    this.imageUrl,
    this.videoUrl,
  });

  factory Post.fromFirestore(Map<String, dynamic> firestore, String id) {
    return Post(
      title: firestore['title'] ?? '',
      timestamp: firestore['timestamp'] ?? '',
      bodies: firestore['bodies'] ?? '',
      imageUrl: firestore['imageUrl'],
      videoUrl: firestore['videoUrl'],
    );
  }
}

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadMedia(XFile file, String folder) async {
    File fileToUpload = File(file.path);
    try {
      String filePath =
          '$folder/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      TaskSnapshot uploadTask =
          await _storage.ref(filePath).putFile(fileToUpload);
      return await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addPost(Post post) async {
    await _db.collection('posts').add({
      'title': post.title,
      'timestamp': post.timestamp,
      'bodies': post.bodies,
      'imageUrl': post.imageUrl,
      'videoUrl': post.videoUrl,
    });
  }
}

class AddPostButton extends StatelessWidget {
  final Function(Post) onPostAdded;

  const AddPostButton({super.key, required this.onPostAdded});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AddPostScreen(onPostAdded: onPostAdded);
            },
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}

class AddPostScreen extends StatefulWidget {
  final Function(Post) onPostAdded;

  const AddPostScreen({super.key, required this.onPostAdded});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  XFile? _image;
  XFile? _video;
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoController;

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print('No image selected.');
      }
    });
  }

  Future getVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _video = pickedFile;
        _videoController = VideoPlayerController.file(File(_video!.path))
          ..initialize().then((_) {
            setState(() {});
            _videoController!.play();
          });
      } else {
        print('No video selected.');
      }
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a Post'),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(labelText: 'Body Text'),
                  maxLines: null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: getImage,
                  child: const Text('Pick Image'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: getVideo,
                  child: const Text('Pick Video'),
                ),
                if (_image != null)
                  Image.file(
                    File(_image!.path),
                    height: 200,
                    width: 200,
                  ),
                if (_video != null)
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final postText = titleController.text;
                    final bodyText = bodyController.text;
                    if (postText.isNotEmpty && bodyText.isNotEmpty) {
                      String? imageUrl;
                      String? videoUrl;

                      if (_image != null) {
                        imageUrl = await StorageService()
                            .uploadMedia(_image!, 'post_images');
                      }

                      if (_video != null) {
                        videoUrl = await StorageService()
                            .uploadMedia(_video!, 'post_videos');
                      }

                      final post = Post(
                        title: postText,
                        timestamp: DateTime.now().toIso8601String(),
                        bodies: bodyText,
                        imageUrl: imageUrl,
                        videoUrl: videoUrl,
                      );

                      await FirestoreService().addPost(post);
                      widget.onPostAdded(post);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Title and body cannot be empty.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit Post'),
                ),
              ],
            ),
          ),
        ));
  }
}
