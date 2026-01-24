import 'package:flutter/material.dart';
import '../../../style/colors.dart';
import '../../../style/fonts.dart';

class LoginField extends StatefulWidget {
  const LoginField({Key? key}) : super(key: key);

  @override
  _LoginFieldState createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: RTColorStyle.light600.value,
      style: RTFontStyle.loginTextField.value,
      decoration: InputDecoration(
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
