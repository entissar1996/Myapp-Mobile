import 'package:flutter/material.dart';
import 'package:myapp/widgets/header.dart';
import 'package:myapp/widgets/progress.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//CollectionReference users = FirebaseFirestore.instance.collection('user');
final  users =FirebaseFirestore.instance.collection('user');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('user').snapshots();

  @override
  void initState(){
  //createUser();
  super.initState();
}
  createUser()async {
    return await users
        .add({
      'fullname': "ddd", // John Doe
      'adress': "tn", // Stokes and Sons
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['fullname']),
            );

          }).toList(),
        );
      },
    );

  }

}
