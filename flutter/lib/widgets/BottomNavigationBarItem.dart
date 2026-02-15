import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../style/colors.dart';
import '../../style/fonts.dart';

BottomNavigationBarItem buildNavItem({
  required String assetPath,
  required String label,
  required double imageSize,
  required double imageActiveSize,
}) {
  return BottomNavigationBarItem(
    icon: SvgPicture.asset(
      assetPath,
      width: imageSize,
      height: imageSize,
    ),
    activeIcon: SvgPicture.asset(
      assetPath,
      width: imageActiveSize,
      height: imageActiveSize,
      colorFilter: ColorFilter.mode(
        RTColorStyle.beige900.value,
        BlendMode.srcIn,
      ),
    ),
    label: label,
  );
}

