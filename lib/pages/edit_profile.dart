import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:myapp/components/photo_profil.dart';
import 'package:myapp/components/rounded_button.dart';
import 'package:myapp/components/rounded_input_field.dart';
import 'package:myapp/components/text_field_container.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/pages/home.dart';
import 'package:myapp/pages/profile.dart';
import 'package:myapp/widgets/progress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

import '../constants.dart';


class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({required this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  User user=User(email: '', id: '', photoUrl: "", displayName: '', username: '', bio: '');

  bool isLoading = false;
  bool _displayNameValid = true;
  bool _bioValid = true;

  @override
void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  getUser()async{
    setState(() {
      isLoading=true;
    });
    DocumentSnapshot doc =await userRef.doc(widget.currentUserId).get();
    user=User.fromDocument(doc);
    displayNameController.text=user.displayName;
    bioController.text=user.bio;
    setState(() {
      isLoading=false;
    });
  }

  File _image =File("");

  bool isUploading = false;
  String postId = Uuid().v4();
  final picker = ImagePicker();

  getImage() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);

    setState(() {_image = File(pickedFile!.path);
    });
  }

  getImagegallery() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  selectImage(parentcontext) {
    return showDialog(
        context: parentcontext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create Post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: getImage,
              ),
              SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: getImagegallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  TextFieldContainer buildDisplayNameField() {
    return TextFieldContainer(
      nb: 0.8,
      child: TextFormField(
        controller: displayNameController,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: kPrimaryColor,
          ),
          hintText: "update bio profile",
          errorText: _displayNameValid? null : "displayName too short",
          border: InputBorder.none,
        ),
      ),
    );
  }

  TextFieldContainer buildBioField() {
    return TextFieldContainer(
      nb: 0.8,
      child: TextFormField(
        controller: bioController,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            Icons.book,
            color: kPrimaryColor,
          ),
          hintText: "update bio profile",
          errorText: _bioValid? null : "bio too short",
          border: InputBorder.none,
        ),
      ),
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
          displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      bioController.text.trim().length > 100
          ? _bioValid = false
          : _bioValid = true;
    });

    if (_displayNameValid && _bioValid) {
      usersRef.doc(widget.currentUserId).update({
        "displayName": displayNameController.text,
        "bio": bioController.text,
      });
      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      _scaffoldKey.currentState!.showSnackBar(snackbar);
    }
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }
  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    dynamic imageFile = Im.decodeImage(_image.readAsBytesSync());
    final compressedImageFile = File("$path/img_$postId.jpg")
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      _image = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
    storageRef.child("post_$postId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handleSubmit() async {

    await compressImage();
    String mediaUrl = await uploadImage(_image);
    usersRef.doc(widget.currentUserId).update({
      "photoUrl":  mediaUrl,
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(profileId:currentUser.id))),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                PhotoProfile(
                  imagePath: user.photoUrl,

                  isEdit: true,
                  onClicked: () async {
                    selectImage(context);
                    await handleSubmit();
                  },
                ),
                /*Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                    CachedNetworkImageProvider(user.photoUrl),
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      buildDisplayNameField(),
                      buildBioField(),
                    ],
                  ),
                ),

                RaisedButton(
                  onPressed: updateProfileData,
                  child: Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: FlatButton.icon(
                    onPressed: logout,
                    icon: Icon(Icons.cancel, color: Colors.red),
                    label: Text(
                      "Logout",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
