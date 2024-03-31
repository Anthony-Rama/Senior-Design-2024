import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/SocialMedia/create_post.dart';
import 'package:mobileapp/SocialMedia/feed.dart';
import 'package:mobileapp/SocialMedia/profile_screen.dart';
import 'package:mobileapp/SocialMedia/search_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void addNewPost(Post newPost) {
    setState(() {
      posts.insert(0, newPost);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          FeedScreen(posts: posts),
          const SearchScreen(),
          Container(), // We don't need to render AddPostScreen directly here
          const Center(child: Text('Notifs')),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Notifs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            // If Add Post button is tapped, navigate to AddPostScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPostScreen(
                  onPostAdded: (post) {
                    addNewPost(post);
                    pageController.jumpToPage(0); // Navigate to FeedScreen
                  },
                ),
              ),
            );
          } else {
            // For other bottom nav items, change page
            navigationTapped(index);
          }
        },
        currentIndex: _page,
      ),
    );
  }
}
