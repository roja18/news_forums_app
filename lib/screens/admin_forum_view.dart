import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminForum extends StatefulWidget {
  const AdminForum({super.key});

  @override
  State<AdminForum> createState() => _AdminForumState();
}

class _AdminForumState extends State<AdminForum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.lightGreen),
          child: const Padding(
            padding: EdgeInsets.only(top: 80.0, left: 22.0),
            child: Text(
              "ATC \nNews & Forum",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white70,
            ),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 8.0, right: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: 'Forum Post', color: Colors.green),
                    SizedBox(height: 10.0),
                    AdminForumSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const SectionHeader({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class AdminForumSection extends StatelessWidget {
  const AdminForumSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('forum').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No forum posts available'));
        }

        var forumDocs = snapshot.data!.docs;

        return Column(
          children: forumDocs.map((doc) {
            return ForumCard(
              postId: doc.id,
              uid: doc['uid'],
              timestamp: (doc['timestamp'] as Timestamp).toDate(),
              description: doc['description'],
              imageUrl: doc['imageUrl'],
            );
          }).toList(),
        );
      },
    );
  }
}

class ForumCard extends StatefulWidget {
  final String postId;
  final String uid;
  final DateTime timestamp;
  final String description;
  final String imageUrl;

  const ForumCard({
    super.key,
    required this.postId,
    required this.uid,
    required this.timestamp,
    required this.description,
    required this.imageUrl,
  });

  @override
  _ForumCardState createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  bool isLiked = false;
  int likeCount = 0;
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
    _getLikeCount();
  }

  Future<void> _checkIfLiked() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var likeDoc = await FirebaseFirestore.instance
        .collection('forum')
        .doc(widget.postId)
        .collection('forumlike')
        .doc(uid)
        .get();

    if (likeDoc.exists) {
      setState(() {
        isLiked = true;
      });
    }
  }

  Future<void> _getLikeCount() async {
    var likeSnapshot = await FirebaseFirestore.instance
        .collection('forum')
        .doc(widget.postId)
        .collection('forumlike')
        .get();

    setState(() {
      likeCount = likeSnapshot.docs.length;
    });
  }

  Future<String> _getFullName(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data()!['fullname'];
    } else {
      return 'Unknown User';
    }
  }

  Future<void> _likeButton() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var likeRef = FirebaseFirestore.instance
        .collection('forum')
        .doc(widget.postId)
        .collection('forumlike')
        .doc(uid);

    if (isLiked) {
      await likeRef.delete();
      setState(() {
        isLiked = false;
        likeCount--;
      });
    } else {
      await likeRef.set({
        'uid': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        isLiked = true;
        likeCount++;
      });
    }
  }

  Future<void> _addComment() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var comment = _commentController.text;

    if (comment.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('forum')
          .doc(widget.postId)
          .collection('forumcomment')
          .add({
        'uid': uid,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Colors.green),
                  SizedBox(width: 7),
                  FutureBuilder<String>(
                    future: _getFullName(widget.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text(
                          snapshot.data!,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              Text(
                '${widget.timestamp.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
              SizedBox(height: 4.0),
              Text(
                widget.description,
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 4.0),
              widget.imageUrl.isNotEmpty
                  ? Image.network(widget.imageUrl)
                  : Container(),
              Row(
                children: [
                  IconButton(
                    onPressed: _likeButton,
                    icon: Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.green : Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.chat_bubble),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('$likeCount likes'),
                  SizedBox(width: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('forum')
                        .doc(widget.postId)
                        .collection('forumcomment')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('0 Comments');
                      }
                      var commentCount = snapshot.data!.docs.length;
                      return Text('$commentCount Comments');
                    },
                  ),
                ],
              ),
              Divider(),
              Column(
                children: [
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _addComment,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('forum')
                        .doc(widget.postId)
                        .collection('forumcomment')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var comments = snapshot.data!.docs;

                      return ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: comments.map((doc) {
                          var commentData = doc.data() as Map<String, dynamic>;
                          var uid = commentData['uid'];
                          var comment = commentData['comment'];
                          var timestamp =
                              (commentData['timestamp'] as Timestamp).toDate();

                          return ListTile(
                            title: FutureBuilder<String>(
                              future: _getFullName(uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text('Loading...');
                                }
                                return Text(snapshot.data!);
                              },
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment),
                                Text(
                                  '${timestamp.toLocal()}'.split(' ')[0],
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
