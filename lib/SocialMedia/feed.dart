import 'package:flutter/material.dart';
import 'package:mobileapp/SocialMedia/create_post.dart';
import 'package:mobileapp/platforms/sidemenu.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

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
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddPostScreen(
                        onPostAdded: (Post newPost) {},
                      )));
            },
          ),
        ],
      ),
      drawer: const sideMenu(),
      body: const Center(
        child: Text('Feed content goes here'), // Placeholder for feed content
      ),
    );
  }
}
