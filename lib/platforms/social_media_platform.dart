import 'package:flutter/material.dart';
import 'package:mobileapp/SocialMedia/feed.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          FeedScreen(),
          Center(child: Text('Search')),
          Center(child: Text('Add Post')),
          Center(child: Text('Notifs')),
          Center(child: Text('Profile')),
        ],
        physics:
            NeverScrollableScrollPhysics(), // Prevents swiping to switch tabs
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed type for more than 3 items
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red, // Change as needed
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
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
