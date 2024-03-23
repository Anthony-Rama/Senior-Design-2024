import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:mobileapp/SocialMedia/create_post.dart';
import 'package:mobileapp/platforms/sidemenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUser(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _db.collection('users').doc(userId).get();

      return userDoc;
    } catch (e) {
      print('Error getting user: $e');
      throw e;
    }
  }

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
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key, required List<Post> posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final Map<String, dynamic> _userDataCache = {};

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title:
            const Text('BELLBOARD FEED', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: const sideMenu(),
      body: FutureBuilder<List<Post>>(
        future: FirestoreService().getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Post>? posts = snapshot.data;

            if (posts == null || posts.isEmpty) {
              return Center(child: Text('No posts available'));
            }

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return _buildPostItem(context, post, _userDataCache);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildPostItem(
      BuildContext context, Post post, Map<String, dynamic> userDataCache) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirestoreService().getUser(post.userId),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: double.infinity,
                    child: LinearProgressIndicator(),
                  );
                } else if (userSnapshot.hasError) {
                  return Text('Error loading user: ${userSnapshot.error}');
                } else {
                  final userData = userSnapshot.data!;
                  final userName = userData['username'] ?? 'Unknown User';

                  return Row(
                    children: [
                      Text(
                        '$userName',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            if (post.imageUrl != null)
              Image.network(
                post.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            if (post.videoUrl != null)
              _VideoPlayerWidget(videoUrl: post.videoUrl!),
            const SizedBox(height: 8),
            Text(
              post.caption,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: Colors.red[400]),
                      onPressed: () {
                        // Implement like functionality
                      },
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment, color: Colors.red[400]),
                      onPressed: () {
                        // Implement comment functionality
                      },
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildTimestamp(post.timestamp),
          ],
        ),
      ),
    );
  }

  Widget _buildTimestamp(String? timestamp) {
    final formattedTimestamp = _formatTimestamp(timestamp);
    return Text(
      formattedTimestamp,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    );
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) {
      return 'Unknown Time';
    }

    try {
      final dateTime = DateTime.parse(timestamp);

      final formattedTime = '${dateTime.hour}:${dateTime.minute}';
      final formattedDate =
          '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      return '$formattedTime, $formattedDate';
    } catch (e) {
      print('Error formatting timestamp: $e');
      return 'Unknown Time';
    }
  }
}

class _VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const _VideoPlayerWidget({required this.videoUrl, Key? key})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              _VideoPlayerControls(controller: _controller),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _VideoPlayerControls extends StatelessWidget {
  final VideoPlayerController controller;

  const _VideoPlayerControls({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VideoProgressIndicator(
          controller,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: Colors.red,
            bufferedColor: Colors.grey,
            backgroundColor: Colors.black,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.replay_5),
                onPressed: () {
                  controller
                      .seekTo(controller.value.position - Duration(seconds: 5));
                },
              ),
              IconButton(
                icon: Icon(controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow),
                onPressed: () {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_5),
                onPressed: () {
                  controller
                      .seekTo(controller.value.position + Duration(seconds: 5));
                },
              ),
              IconButton(
                icon: Icon(
                  controller.value.volume == 0
                      ? Icons.volume_off
                      : Icons.volume_up,
                ),
                onPressed: () {
                  controller
                      .setVolume(controller.value.volume == 0 ? 1.0 : 0.0);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VideoPlayerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const VideoPlayerButton({
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}
