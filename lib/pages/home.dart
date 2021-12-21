import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/pages/activity_feed.dart';
import 'package:myapp/pages/profile.dart';
import 'package:myapp/pages/search.dart';
import 'package:myapp/pages/timeline.dart';
import 'package:myapp/pages/upload.dart';

import 'create_account.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final Reference storageRef=FirebaseStorage.instance.ref();
final usersRef =FirebaseFirestore.instance.collection("user");
final postsRef =FirebaseFirestore.instance.collection("posts");

final commentsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final userRef = FirebaseFirestore.instance.collection('user').withConverter<User>(
  fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
  toFirestore: (user, _) => user.toJson(),
);

 User currentUser=User(email: '', id: '', photoUrl: "", displayName: '', username: '', bio: '');
final DateTime timestamp=DateTime.now();
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController? pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
//Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print("Error signed in ! : $err");
    });
    //Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print("Error signing in :$err");
    });
  }

  handleSignIn(account) {
    if (account != null) {
      //print("User signed in ! : $account");
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }
  createUserInFirestore() async {
    final GoogleSignInAccount? user = googleSignIn.currentUser;

     DocumentSnapshot doc = await usersRef.doc(user!.id).get();
    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      usersRef.doc(user.id).set({'id': user.id,
         "username": username,
         'email': user.email,
         'photoUrl': user.photoUrl,
         'displayName': user.displayName,
         'bio': '',
         'timestamp': timestamp, // John Doe
       } ).then((value) => print("User Added"))
           .catchError((error) => print("Failed to add user: $error"));
      doc = await usersRef.doc(user.id).get();

    }

    currentUser = User.fromDocument(doc);

  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController!.animateToPage(pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: [
          //Timeline(),
          RaisedButton(
            child: Text("logout"),
            onPressed: logout,
          ),
          ActivityFeed(),
          Upload(currentUser:currentUser),
          Search(),
          Profile(profileId:currentUser.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 35.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
    //return Text("authenticated");
    //return RaisedButton(child: Text("logout"),onPressed: logout,);
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor,
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("flutterShare",
                    style: TextStyle(
                        fontFamily: "Signatra",
                        fontSize: 90.0,
                        color: Colors.white)),
                GestureDetector(
                    onTap: login,
                    child: Container(
                        width: 260.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/google_signin_button.png"),
                            fit: BoxFit.cover,
                          ),
                        )))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
