import 'package:flutter/material.dart';
import '../../../style/colors.dart';
import '../../../style/fonts.dart';

class AuthButton extends StatefulWidget {
  const AuthButton({Key? key}) : super(key: key);

  @override
  _AuthButtonState createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {

  @override
  Widget build(BuildContext context) {
      return TextField(
        cursorColor: RTColorStyle.light600.value,
        style: RTFontStyle.loginTextField.value,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 2, // controls height
            horizontal: 12,
          ),
          filled: true,
          fillColor: RTColorStyle.bgLoginTextField.value, 
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: RTColorStyle.beige700.value, width: 1),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      );
    }
}
