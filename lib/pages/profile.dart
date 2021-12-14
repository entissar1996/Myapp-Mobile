//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/edit_profile.dart';
import 'package:myapp/pages/home.dart';
import 'package:myapp/widgets/header.dart';
import 'package:myapp/widgets/progress.dart';
import 'package:myapp/models/user.dart';

class Profile extends StatefulWidget {
  final String profileId;
  Profile({required this.profileId});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId=currentUser.id;
Column  buildCountColumn(String label, int count){
    return  Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
        style: TextStyle(fontSize:22.0, fontWeight:FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color:Colors.grey,
              fontSize:15.0,
              fontWeight:FontWeight.w400,
            )
          ),
        ),
      ],
    );
  }
  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(currentUserId: currentUserId)));
  }
  Container buildButton({required String text,required void Function() function}){
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color:  Colors.black ,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:  Colors.blue,
            border: Border.all(
              color:  Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
buildProfileButton(){
  bool isProfileOwner=currentUserId==widget.profileId;
  if (isProfileOwner) {
    return buildButton(
      text: "Edit Profile",
      function: editProfile,
    );
  }
}
  buildProfileHeader(){
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(widget.profileId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
              padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                  Row(
                    children:<Widget>[
                      CircleAvatar(
                          radius: 40.0,
                        backgroundColor: Colors.grey,
                        backgroundImage: CachedNetworkImageProvider(data['photoUrl']),

                      ),
                      Expanded(
                        flex: 1,
                        child:Column(
                          children:<Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                buildCountColumn("Posts",0),
                                buildCountColumn("Followers",0),
                                buildCountColumn("Following",0),

                              ],
                            ),
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  buildProfileButton(),
                                ],
                            ),
                          ],
                        ),
                      ),
                    ],),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 12.0),
                  child: Text(
                      data['displayName'],
                    style: TextStyle(
                      fontWeight:FontWeight.bold,
                      fontSize:16.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    data['username'],
                    style: TextStyle(
                      fontWeight:FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 2.0),
                  child: Text(
                    data['bio'],

                    ),
                  ),


              ],
            ),

          );
        }

        return Text("loading");
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,titleText: "Profile"),
      body: ListView(
        children: <Widget>[
          buildProfileHeader()
        ],
      ),
    );
  }
}
