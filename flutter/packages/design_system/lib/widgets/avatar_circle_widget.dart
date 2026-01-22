import 'package:design_system/style/colors.dart';
import 'package:flutter/material.dart';

class DSAvatarCircleWidget extends StatelessWidget {
  final String avatarLink;
  final double radius;
  final bool needBorder;
  final Color? borderColor;
  final double? borderWidth;

  const DSAvatarCircleWidget(
      {super.key,
      required this.avatarLink,
      this.radius = 20.0,
      this.needBorder = false,
      this.borderColor,
      this.borderWidth});

  @override
  Widget build(BuildContext context) {
    bool isValidURL = Uri.parse(avatarLink).isAbsolute;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
              strokeAlign: BorderSide.strokeAlignOutside,
              color: needBorder
                  ? borderColor ?? Colors.transparent
                  : Colors.transparent,
              width: needBorder ? borderWidth ?? 0.0 : 0.0)),
      child: CircleAvatar(
          radius: radius,
          foregroundImage: isValidURL ? NetworkImage(avatarLink) : null,
          backgroundImage:
              isValidURL ? null : AssetImage("assets/images/person.png"),
          backgroundColor: DSColorStyle.beige600.value),
    );
  }
}
