import 'package:flutter/material.dart';

// Color style

enum RTColorStyle {
  beige1000,
  beige900,
  beige800,
  beige700,
  beige600,
  beige500,
  beige400,
  beige300,

  systemError,
  systemSuccess,
  systemWarning,

  light1000,
  light900,
  light800,
  light700,
  light600,
  light500,
  light400,
  light300,

  bgLoginTextField,
  dark1000,
  dark900,
  dark800,
  dark700,
  dark600,
  dark500,
  dark400,
  dark300,
}

extension RTColorStyleExtension on RTColorStyle {
  Color get value {
    switch (this) {
      case RTColorStyle.bgLoginTextField:
        return const Color(0xFF313336);

      case RTColorStyle.beige1000:
        return const Color(0xFFDDB79A);
      case RTColorStyle.beige900:
        return const Color(0xE0DDB79A);
      case RTColorStyle.beige800:
        return const Color(0xB8DDB79A);
      case RTColorStyle.beige700:
        return const Color(0x8FDDB79A);
      case RTColorStyle.beige600:
        return const Color(0x52DDB79A);
      case RTColorStyle.beige500:
        return const Color(0x33DDB79A);
      case RTColorStyle.beige400:
        return const Color(0x14DDB79A);
      case RTColorStyle.beige300:
        return const Color(0x0ADDB79A);
      case RTColorStyle.systemError:
        return const Color(0xFFFF471F);
      case RTColorStyle.systemSuccess:
        return const Color(0xFF21993B);
      case RTColorStyle.systemWarning:
        return const Color(0xFFFF9028);
      case RTColorStyle.light1000:
        return const Color(0xFFFFFFFF);
      case RTColorStyle.light900:
        return const Color(0xE0FFFFFF);
      case RTColorStyle.light800:
        return const Color(0xB8FFFFFF);
      case RTColorStyle.light700:
        return const Color(0x8FFFFFFF);
      case RTColorStyle.light600:
        return const Color(0x52FFFFFF);
      case RTColorStyle.light500:
        return const Color(0x33FFFFFF);
      case RTColorStyle.light400:
        return const Color(0x14FFFFFF);
      case RTColorStyle.light300:
        return const Color(0x08FFFFFF);
      case RTColorStyle.dark1000:
        return const Color(0xFF252629);
      case RTColorStyle.dark900:
        return const Color(0xFF404043);
      case RTColorStyle.dark800:
        return const Color(0xFF626265);
      case RTColorStyle.dark700:
        return const Color(0xFF858587);
      case RTColorStyle.dark600:
        return const Color(0xFFB9B9BA);
      case RTColorStyle.dark500:
        return const Color(0xFFD3D4D4);
      case RTColorStyle.dark400:
        return const Color(0xFFEEEEEE);
      case RTColorStyle.dark300:
        return const Color(0xFFF6F7F7);
    }
  }
}
