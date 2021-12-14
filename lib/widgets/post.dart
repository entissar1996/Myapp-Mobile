import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/pages/comments.dart';
import 'package:myapp/pages/home.dart';
import 'package:myapp/widgets/progress.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  Post({
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.description,
    required this.mediaUrl,
    this.likes,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() =>
      _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        username: this.username,
        location: this.location,
        description: this.description,
        mediaUrl: this.mediaUrl,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
      );
}

class _PostState extends State<Post> {
  final String currentUserId = currentUser.id;
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  bool showHeart = false;
  bool isLiked = false;
  int likeCount;
  Map likes;

  _PostState({
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.description,
    required this.mediaUrl,
    required this.likes,
    required this.likeCount,
  });

  buildPostHeader() {
    return FutureBuilder<DocumentSnapshot>(
        future: usersRef.doc(ownerId).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<
                String,
                dynamic>;
            bool isPostOwner = currentUserId == ownerId;
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(data['photoUrl']),
                backgroundColor: Colors.grey,
              ),
              title: GestureDetector(
                onTap: () => print("showing profile"),
                //showProfile(context, profileId: data['id']),
                child: Text(
                  data['username'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Text(location),
              trailing: isPostOwner
                  ? IconButton(
                onPressed: () => print("delete post"),
                icon: Icon(Icons.more_vert),
              )
                  : Text('nnnn'),
            );
          }
          return Text("loading");

        },
    );
  }


  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserId] == true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),

      ],
    );
  }
}
//tttttttt
/*showComments(BuildContext context,
    {required String postId, required String ownerId, required String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(
      postId: postId,
      postOwnerId: ownerId,
      postMediaUrl: mediaUrl,
    );
  }));*/

