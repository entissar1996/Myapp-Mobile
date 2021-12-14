import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  final String id;
  final String email;
  final String username;
  final String photoUrl;
  final String displayName;
  final String bio;/*
  User({required this.id, required this.email, required this.username, required this.photoUrl, required this.displayName, required this.bio});

 factory User.fromDocument(DocumentSnapshot doc){
   return User(id: doc['id'], email: doc['email'], username: doc['username'], photoUrl: doc['photoUrl'], displayName: doc['displayName'], bio: doc['bio']);
 }*/
  User( {required this.id, required this.email, required this.username, required this.photoUrl, required this.displayName, required this.bio});

  User.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    username: json['username']! as String,
    email: json['email']! as String,
    photoUrl: json['photoUrl']! as String,
    displayName: json['displayName']! as String,
    bio: json['bio']! as String,

  );

  factory User.fromDocument(DocumentSnapshot doc){
    return User(id: doc['id'], email: doc['email'], username: doc['username'], photoUrl: doc['photoUrl'], displayName: doc['displayName'], bio: doc['bio']);
  }

  Map<String, Object?> toJson() {
    return {
      id: 'id',
      username: 'username',
      email: 'email',
      photoUrl:'photoUrl',
      displayName: 'displayName',
      bio: 'bio',
    };
  }
}
