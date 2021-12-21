import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final double nb;
  final Widget child;
  const TextFieldContainer({
    required this.nb,
    required this.child,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * nb,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
