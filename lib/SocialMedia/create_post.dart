import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobileapp/SocialMedia/comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  final String id;
  final String username;
  final String userId;
  final String timestamp;
  final String? imageUrl;
  final String? videoUrl;
  final String caption;
  List<Comment> comments;
  int likes;
  List<String> likedBy;

  Post({
    required this.id,
    required this.username,
    required this.userId,
    required this.timestamp,
    this.imageUrl,
    this.videoUrl,
    required this.caption,
    this.comments = const [],
    this.likes = 0,
    List<String>? likedBy,
  }) : likedBy = likedBy ?? [];

  factory Post.fromFirestore(Map<String, dynamic> firestore, String id) {
    return Post(
      id: id,
      username: firestore['username'] ?? 'Unknown User',
      userId: firestore['userId'] ?? '',
      timestamp: firestore['timestamp'] ?? DateTime.now().toString(),
      imageUrl: firestore['imageUrl'],
      videoUrl: firestore['videoUrl'],
      caption: firestore['caption'] ?? '',
      comments: [],
      likes: firestore['likes'] ?? 0,
      likedBy: List<String>.from(firestore['likedBy'] ?? []),
    );
  }

  void toggleLike(String userId) {
    if (likedBy.contains(userId)) {
      likedBy.remove(userId);
      likes--;
    } else {
      likedBy.add(userId);
      likes++;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'userId': userId,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'caption': caption,
      'likes': likes,
      'likedBy': likedBy,
    };
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
      await _db.collection('posts').add(post.toMap());
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
  final TextEditingController _bodyController = TextEditingController();
  XFile? _image;
  XFile? _video;
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoController;
  bool _isUploading = false;

  void _getImage() async {
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

  void _getVideo() async {
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

  String _generatePostId() {
    return FirebaseFirestore.instance.collection('posts').doc().id;
  }

  Future<void> _submitPost() async {
    final captionText = _bodyController.text.trim();
    if (captionText.isEmpty || _isUploading) return;

    setState(() {
      _isUploading = true;
    });

    String? imageUrl;
    String? videoUrl;

    if (_image != null) {
      imageUrl = await StorageService().uploadMedia(_image!, 'post_images');
    }

    if (_video != null) {
      videoUrl = await StorageService().uploadMedia(_video!, 'post_videos');
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentSnapshot userSnapshot =
          await db.collection('users').doc(user.uid).get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final username = userData['username'] ?? 'Unknown User';
        final post = Post(
          id: _generatePostId(),
          username: username,
          userId: user.uid,
          timestamp: DateTime.now().toString(),
          caption: captionText,
          imageUrl: imageUrl,
          videoUrl: videoUrl,
        );

        await FirestoreService().addPost(post);
        widget.onPostAdded(post);

        Navigator.pop(context, true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User is not signed in.'),
        ),
      );
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
                  onPressed: _getImage,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red[400],
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
                  onPressed: _getVideo,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red[400],
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
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Add a caption'),
                maxLines: null,
              ),
              ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red[400],
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
