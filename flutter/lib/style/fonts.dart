import './colors.dart';
import 'package:flutter/material.dart';


enum RTFontStyle {
  h1,
  h2,
  loginLabels,
  loginTextField,
  appTitle,
  PublishedAt,

  h5,
  bodyXL,
  bodyL,
  bodyM,
  bodyS,
  bodyXS,
  bodyXXS
}

extension RTFontStyleExtension on RTFontStyle {
  TextStyle get value {
    switch (this) {

      case RTFontStyle.h1:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 32,
            height: 36 / 32,
            fontWeight: FontWeight.w700,
            package: "design_system");

      case RTFontStyle.h2:
        return TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 24,
            height: 32 / 24,
	    color: RTColorStyle.light1000.value,
            fontWeight: FontWeight.w700,
            package: "design_system");

      case RTFontStyle.loginLabels:
        return TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 16,
            height: 24 / 20,
            fontWeight: FontWeight.w300,
	    color: RTColorStyle.light800.value,
            package: "design_system");

      case RTFontStyle.appTitle:
        return TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 20,
            height: 24 / 20,
            fontWeight: FontWeight.w700,
            package: "design_system",
	    color: RTColorStyle.beige1000.value);

      case RTFontStyle.loginTextField:
        return TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 16,
            height: 24 / 20,
            fontWeight: FontWeight.w600,
            package: "design_system",
	    color: RTColorStyle.light800.value);

      case RTFontStyle.PublishedAt:
        return TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 13,
            height: 20 / 17,
            fontWeight: FontWeight.w700,
            package: "design_system",
	    color: RTColorStyle.dark600.value);



      case RTFontStyle.h5:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 15,
            height: 20 / 15,
            fontWeight: FontWeight.w700,
            package: "design_system");
      case RTFontStyle.bodyXL:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.w400,
            package: "design_system");
      case RTFontStyle.bodyL:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 15,
            height: 20 / 15,
            fontWeight: FontWeight.w400,
            package: "design_system");
      case RTFontStyle.bodyM:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 15,
            height: 20 / 15,
            fontWeight: FontWeight.w700,
            package: "design_system");
      case RTFontStyle.bodyS:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 13,
            height: 14 / 13,
            fontWeight: FontWeight.w400,
            package: "design_system");
      case RTFontStyle.bodyXS:
        return const TextStyle(
            fontFamily: "MuseoSans",
            fontSize: 12,
            height: 20 / 12,
            fontWeight: FontWeight.w700,
            package: "design_system");
      case RTFontStyle.bodyXXS:
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
    color: RTColorStyle.light1000.value,
    package: "design_system");

TextStyle secondaryNewsStyle = TextStyle(
    fontFamily: "MuseoSans",
    fontSize: 12,
    height: 14 / 12,
    fontWeight: FontWeight.w700,
    color: RTColorStyle.light1000.value,
    decoration: TextDecoration.underline,
    package: "design_system");

TextStyle vacationIntervalStyle = TextStyle(
    fontFamily: "MuseoSans",
    fontSize: 13,
    height: 14 / 13,
    fontWeight: FontWeight.w700,
    color: RTColorStyle.beige1000.value,
    package: "design_system");

TextStyle vacationAvatarBadgeStyle = TextStyle(
    fontFamily: "MuseoSans",
    fontSize: 8,
    height: 1,
    fontWeight: FontWeight.w400,
    color: RTColorStyle.dark1000.value,
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
    color: RTColorStyle.light700.value,
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
    color: RTColorStyle.light1000.value,
    package: "design_system");
