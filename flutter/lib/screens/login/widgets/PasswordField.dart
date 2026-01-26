import 'package:flutter/material.dart';
import '../../../style/colors.dart';
import '../../../style/fonts.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;  

  const PasswordField({
    super.key,
    required this.controller,
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
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
        suffixIcon: IconButton(
          icon: Icon(
	    color: RTColorStyle.light600.value,
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

