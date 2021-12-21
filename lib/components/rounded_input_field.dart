import 'package:flutter/material.dart';
import 'package:myapp/components/text_field_container.dart';
import 'package:myapp/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
final TextEditingController controller;
final String errorText;
  const RoundedInputField({
    required  this.errorText,
    required this.controller,
    required this.hintText,
    required this.icon,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      nb: 0.8,
      child: TextFormField(
        controller: controller,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          errorText:  errorText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
