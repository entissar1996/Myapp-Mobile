import 'package:flutter/material.dart';

AppBar header(context,{bool isAppTitle=false,String titleText= "",removeBackButton=false}) {
  return AppBar(
    automaticallyImplyLeading:removeBackButton =true,
    title: Text(
      isAppTitle ? 'BestPlace' : titleText,
      style: TextStyle(
          color: Colors.white,
          fontFamily: isAppTitle ? "Signatra" :"",
          fontSize: isAppTitle ? 50.0 : 22.0),
    ),
    centerTitle: true,
    backgroundColor: Colors.purple.shade300,
  );
}
