import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comment {
  final String username;
  final String userId;
  final String? profileImageUrl;
  final String commentText;

  Comment({
    required this.username,
    required this.userId,
    this.profileImageUrl,
    required this.commentText,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userId': userId,
      'profileImageUrl': profileImageUrl,
      'commentText': commentText,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      username: map['username'] ?? 'Unknown User',
      userId: map['userId'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      commentText: map['commentText'] ?? '',
    );
  }
}

class AddCommentScreen extends StatefulWidget {
  final String postId;

  const AddCommentScreen({super.key, required this.postId});

  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final TextEditingController commentController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late User _currentUser;
  String _currentUserUsername = 'Unknown User';
  String _currentUserProfileImageUrl = '';
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchComments();
  }

  void _getCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot userSnapshot =
        await _db.collection('users').doc(_currentUser.uid).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _currentUserUsername = userData['username'] ?? 'Unknown User';
        _currentUserProfileImageUrl = userData['profileImageUrl'] ?? '';
      });
    }
  }

  void _fetchComments() async {
    try {
      DocumentSnapshot postSnapshot =
          await _db.collection('posts').doc(widget.postId).get();
      if (postSnapshot.exists) {
        List<dynamic>? commentsData = postSnapshot['comments'];
        if (commentsData != null) {
          List<Comment> fetchedComments = commentsData
              .map(
                (comment) => Comment.fromMap(comment),
              )
              .toList();
          setState(() {
            comments = fetchedComments;
          });
        }
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  void _submitComment() async {
    String commentText = commentController.text.trim();
    if (commentText.isNotEmpty) {
      Comment newComment = Comment(
        username: _currentUserUsername,
        userId: _currentUser.uid,
        profileImageUrl: _currentUserProfileImageUrl,
        commentText: commentText,
      );

      try {
        await _db.collection('posts').doc(widget.postId).update({
          'comments': FieldValue.arrayUnion([newComment.toMap()])
        });

        setState(() {
          comments.add(newComment);
        });
      } catch (e) {
        print('Error adding comment: $e');
      }

      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: const Text('ADD COMMENT', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(comments[index].profileImageUrl ?? ''),
                    ),
                    title: Text(comments[index].username),
                    subtitle: Text(comments[index].commentText),
                  );
                },
              ),
            ),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: 'Write a comment...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitComment,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red[400],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.red[400]!),
                ),
              ),
              child: const Text('SUBMIT COMMENT'),
            ),
          ],
        ),
      ),
    );
  }
}
