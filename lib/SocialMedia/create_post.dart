import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobileapp/SocialMedia/feed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  final String userName;
  final String userId;
  final String timestamp;
  final String? imageUrl;
  final String? videoUrl;
  final String caption;

  Post({
    required this.userName,
    required this.userId,
    required this.timestamp,
    this.imageUrl,
    this.videoUrl,
    required this.caption,
  });

  factory Post.fromFirestore(Map<String, dynamic> firestore, String id) {
    return Post(
      userName: firestore['userName'] ?? 'Unknown User',
      userId: firestore['userId'] ?? '',
      timestamp: firestore['timestamp'] ?? DateTime.now().toString(),
      imageUrl: firestore['imageUrl'],
      videoUrl: firestore['videoUrl'],
      caption: firestore['caption'] ?? '',
    );
  }
}

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadMedia(XFile file, String folder) async {
    File fileToUpload = File(file.path);
    try {
      String filePath =
          '$folder/${DateTime.now().millisecondsSinceEpoch}_${file.name ?? 'image'}';

      TaskSnapshot uploadTask =
          await _storage.ref(filePath).putFile(fileToUpload);

      return await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print('Firebase Storage Error: $e');
      return null;
    }
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Post>> getPosts() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('posts').get();
      List<Post> posts = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Post.fromFirestore(data, doc.id);
      }).toList();
      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  Future<void> addPost(Post post) async {
    try {
      await _db.collection('posts').add({
        'userId': post.userId,
        'timestamp': post.timestamp,
        'imageUrl': post.imageUrl,
        'videoUrl': post.videoUrl,
        'caption': post.caption,
      });
    } catch (e) {
      print('Error adding post to Firestore: $e');
    }
  }
}

class AddPostScreen extends StatefulWidget {
  final Function(Post) onPostAdded;

  const AddPostScreen({super.key, required this.onPostAdded});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController bodyController = TextEditingController();

  XFile? _image;
  XFile? _video;
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoController;
  bool _isUploading = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        _video = null;
        _videoController?.pause();
        _videoController = null;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> getVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        setState(() {
          _video = pickedFile;
          _image = null;
          _videoController = VideoPlayerController.file(File(_video!.path))
            ..initialize().then((_) {
              setState(() {});
              _videoController!.play();
            });
        });
      } catch (e) {
        print('Error initializing video player: $e');
      }
    } else {
      print('No video selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: const Text('ADD POST', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_image == null && _video == null) ...[
                ElevatedButton(
                  onPressed: getImage,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red[400],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.red[400]!),
                    ),
                  ),
                  child: const Text('PICK IMAGE'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: getVideo,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red[400],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.red[400]!),
                    ),
                  ),
                  child: const Text('PICK VIDEO'),
                ),
              ],
              if (_image != null)
                Image.file(
                  File(_image!.path),
                  height: 300,
                  width: 400,
                ),
              if (_video != null)
                _videoController != null
                    ? Column(
                        children: [
                          AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_videoController!.value.isPlaying) {
                                _videoController!.pause();
                              } else {
                                _videoController!.play();
                              }
                              setState(() {});
                            },
                            icon: Icon(
                              _videoController!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                          ),
                        ],
                      )
                    : const CircularProgressIndicator(),
              const SizedBox(height: 20),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: 'Add a caption'),
                maxLines: null,
              ),
              ElevatedButton(
                onPressed: () async {
                  final captionText = bodyController.text;
                  if (captionText.isNotEmpty && !_isUploading) {
                    setState(() {
                      _isUploading = true;
                    });

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

                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final post = Post(
                        userName: user.displayName ?? 'Unknown User',
                        userId: user.uid,
                        timestamp: DateTime.now().toString(),
                        caption: captionText,
                        imageUrl: imageUrl,
                        videoUrl: videoUrl,
                      );

                      await FirestoreService().addPost(post);
                      widget.onPostAdded(post);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeedScreen(posts: []),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User is not signed in.'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Caption cannot be empty.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red[400],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.red[400]!),
                  ),
                ),
                child: _isUploading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 10),
                          Text('Uploading...'),
                        ],
                      )
                    : const Text('SUBMIT POST'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
