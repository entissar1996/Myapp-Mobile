import 'package:flutter/material.dart';
import 'package:location/location.dart';

class PermissionStatusWidget extends StatefulWidget {
  const PermissionStatusWidget({Key? key}) : super(key: key);

  @override
  _PermissionStatusState createState() => _PermissionStatusState();
}

class _PermissionStatusState extends State<PermissionStatusWidget> {
  final Location location = Location();

   dynamic _permissionGranted;

  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
    await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
      await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(

          children: <Widget>[

            Container(
              width: 200.0,
              height: 100.0,
              alignment: Alignment.center,
              child: RaisedButton.icon(
                label: Text(
                  "Use Current Location",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.blue,
                onPressed:   _permissionGranted == PermissionStatus.granted
    ? null
        : _requestPermission,
                icon: Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
              ),
            ),
          ],
    );
  }
}
