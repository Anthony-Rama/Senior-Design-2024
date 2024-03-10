import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:mobileapp/SocialMedia/create_post.dart';
import 'package:mobileapp/platforms/sidemenu.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key, required List<Post> posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
                return _buildPostItem(post);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildPostItem(Post post) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        ),
      ),
    );
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
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(_controller),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Colors.red,
                    bufferedColor: Colors.grey,
                    backgroundColor: Colors.black,
                  ),
                ),
                _VideoPlayerControls(controller: _controller),
              ],
            ),
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
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          reverseDuration: Duration(milliseconds: 300),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
        ),
      ],
    );
  }
}
