import 'package:design_system/style/colors.dart';
import 'package:flutter/material.dart';

// Text style
// Important specify package name for use font inside package

enum DSFontStyle {
  h1,
  h2,
  h3,
  h4,
  h5,
  bodyXL,
  bodyL,
  bodyM,
  bodyS,
  bodyXS,
  bodyXXS
}

extension DSFontStyleExtension on DSFontStyle {
  TextStyle get value {
    switch (this) {
      case DSFontStyle.h1:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 32,
            height: 36 / 32,
            fontWeight: FontWeight.w700,
            package: "design_system");
      case DSFontStyle.h2:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 24,
            height: 32 / 24,
            fontWeight: FontWeight.w700,
            package: "design_system");
      case DSFontStyle.h3:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 20,
            height: 24 / 20,
            fontWeight: FontWeight.w700,
            package: "design_system");
      case DSFontStyle.h4:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 17,
            height: 20 / 17,
            fontWeight: FontWeight.w700,
            package: "design_system");
      case DSFontStyle.h5:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 15,
            height: 20 / 15,
            fontWeight: FontWeight.w700,
            package: "design_system");
      case DSFontStyle.bodyXL:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.w400,
            package: "design_system");
      case DSFontStyle.bodyL:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 15,
            height: 20 / 15,
            fontWeight: FontWeight.w400,
            package: "design_system");
      case DSFontStyle.bodyM:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 15,
            height: 20 / 15,
            fontWeight: FontWeight.w700,
            package: "design_system");
      case DSFontStyle.bodyS:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 13,
            height: 14 / 13,
            fontWeight: FontWeight.w400,
            package: "design_system");
      case DSFontStyle.bodyXS:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 12,
            height: 20 / 12,
            fontWeight: FontWeight.w700,
            package: "design_system");
      case DSFontStyle.bodyXXS:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 11,
            height: 20 / 11,
            fontWeight: FontWeight.w400,
            package: "design_system");
    }
  }
}

const TextStyle tabbarStyle = TextStyle(
    fontFamily: "SFProDisplay",
    fontSize: 12,
    fontWeight: FontWeight.w500,
    package: "design_system");

TextStyle primaryNewsStyle = TextStyle(
    fontFamily: "MuseoSans",
    fontSize: 15,
    height: 17 / 15,
    fontWeight: FontWeight.w700,
    color: DSColorStyle.light1000.value,
    package: "design_system");

TextStyle secondaryNewsStyle = TextStyle(
    fontFamily: "MuseoSans",
    fontSize: 12,
    height: 14 / 12,
    fontWeight: FontWeight.w700,
    color: DSColorStyle.light1000.value,
    decoration: TextDecoration.underline,
    package: "design_system");

TextStyle vacationIntervalStyle = TextStyle(
    fontFamily: "MuseoSans",
    fontSize: 13,
    height: 14 / 13,
    fontWeight: FontWeight.w700,
    color: DSColorStyle.beige1000.value,
    package: "design_system");

TextStyle vacationAvatarBadgeStyle = TextStyle(
    fontFamily: "MuseoSans",
    fontSize: 8,
    height: 1,
    fontWeight: FontWeight.w400,
    color: DSColorStyle.dark1000.value,
    package: "design_system");

TextStyle segmentedControlStyle = TextStyle(
    fontFamily: "MuseoSans",
    fontSize: 12,
    height: 14 / 12,
    fontWeight: FontWeight.w700,
    package: "design_system");

TextStyle footnoteStyle = TextStyle(
    fontFamily: "ProximaNova",
    fontSize: 13,
    height: 14 / 13,
    fontWeight: FontWeight.w700,
    color: DSColorStyle.light700.value,
    package: "design_system");

TextStyle chatNameInAvatar = TextStyle(
    fontFamily: "IBMPlexSans",
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w600,
    package: "design_system");

TextStyle aichatUnreadCount = TextStyle(
    fontFamily: "MuseoSans",
    fontSize: 9,
    height: 1,
    fontWeight: FontWeight.w700,
    color: DSColorStyle.light1000.value,
    package: "design_system");
