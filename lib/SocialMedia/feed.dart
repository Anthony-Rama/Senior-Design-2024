import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:mobileapp/SocialMedia/create_post.dart';
import 'package:mobileapp/SocialMedia/comments.dart';
import 'package:mobileapp/platforms/sidemenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updatePostLikes(String postId, int likes) async {
    try {
      await _db.collection('posts').doc(postId).update({
        'likes': likes,
      });
    } catch (e) {
      print('Error updating post likes: $e');
    }
  }

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

  Future<void> deletePost(String postId) async {
    try {
      await _db.collection('posts').doc(postId).delete();
    } catch (e) {
      print('Error deleting post from Firestore: $e');
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

            return ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (context, index) => SizedBox(height: 5.0),
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
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FutureBuilder<DocumentSnapshot>(
              future: FirestoreService().getUser(post.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error loading user: ${snapshot.error}');
                } else {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final username = userData['username'];

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        // pfp
                      ),
                      const SizedBox(width: 8),
                      Text(
                        username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, post);
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          if (post.imageUrl != null)
            Image.network(
              post.imageUrl!,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          if (post.videoUrl != null)
            _VideoPlayerWidget(videoUrl: post.videoUrl!),
          const SizedBox(height: 8),
          //caption
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: FutureBuilder<DocumentSnapshot>(
              future: FirestoreService().getUser(post.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error loading user: ${snapshot.error}');
                } else {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final username = userData['username'];

                  if (post.imageUrl == null && post.videoUrl == null) {
                    return Text(
                      post.caption,
                      style: TextStyle(fontSize: 16),
                    );
                  } else {
                    return RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        children: [
                          TextSpan(
                            text: '$username ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: post.caption,
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          ),
          // likes and comments
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  _likePost(post);
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  // Navigate to AddCommentScreen when comment icon is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCommentScreen(postId: post.id),
                    ),
                  );
                },
              ),
            ],
          ),
          // likes count
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '${post.likes} likes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          // comments section
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comments',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                // display comment count
              ],
            ),
          ),
          _buildTimestamp(post.timestamp),
        ],
      ),
    );
  }

  void _likePost(Post post) {
    post.likes++;
    FirestoreService().updatePostLikes(post.id, post.likes);
  }

  Widget _buildTimestamp(String? timestamp) {
    final formattedTimestamp = _formatTimestamp(timestamp);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: Text(
        formattedTimestamp,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      ),
    );
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) {
      return 'Unknown Time';
    }

    try {
      final dateTime = DateTime.parse(timestamp);

      final formattedDate =
          '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      return '$formattedDate';
    } catch (e) {
      print('Error formatting timestamp: $e');
      return 'Unknown Time';
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Post post) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deletePost(post.id);
              Navigator.of(context).pop();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _deletePost(String postId) {
    FirestoreService().deletePost(postId);
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
