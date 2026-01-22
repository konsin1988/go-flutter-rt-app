import 'package:design_system/style/colors.dart';
import 'package:flutter/material.dart';

IconButton dsSmallAvatarButton(
    {required VoidCallback? onPressed, required String url}) {
  bool isValidURL = Uri.parse(url).isAbsolute;

  return IconButton(
      padding: EdgeInsets.all(0),
      icon: Container(
          width: 40.0, // need for compensate border width
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(color: DSColorStyle.beige1000.value, width: 1.6),
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
              radius: 20,
              foregroundImage: isValidURL ? NetworkImage(url) : null,
              backgroundImage: AssetImage("assets/images/person.png"),
              backgroundColor: Colors.transparent)),
      onPressed: onPressed);
}
