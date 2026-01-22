import 'package:flutter/material.dart';

// Color style

enum DSColorStyle {
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

  dark1000,
  dark900,
  dark800,
  dark700,
  dark600,
  dark500,
  dark400,
  dark300,
}

extension DSColorStyleExtension on DSColorStyle {
  Color get value {
    switch (this) {
      case DSColorStyle.beige1000:
        return const Color(0xFFDDB79A);
      case DSColorStyle.beige900:
        return const Color(0xE0DDB79A);
      case DSColorStyle.beige800:
        return const Color(0xB8DDB79A);
      case DSColorStyle.beige700:
        return const Color(0x8FDDB79A);
      case DSColorStyle.beige600:
        return const Color(0x52DDB79A);
      case DSColorStyle.beige500:
        return const Color(0x33DDB79A);
      case DSColorStyle.beige400:
        return const Color(0x14DDB79A);
      case DSColorStyle.beige300:
        return const Color(0x0ADDB79A);
      case DSColorStyle.systemError:
        return const Color(0xFFFF471F);
      case DSColorStyle.systemSuccess:
        return const Color(0xFF21993B);
      case DSColorStyle.systemWarning:
        return const Color(0xFFFF9028);
      case DSColorStyle.light1000:
        return const Color(0xFFFFFFFF);
      case DSColorStyle.light900:
        return const Color(0xE0FFFFFF);
      case DSColorStyle.light800:
        return const Color(0xB8FFFFFF);
      case DSColorStyle.light700:
        return const Color(0x8FFFFFFF);
      case DSColorStyle.light600:
        return const Color(0x52FFFFFF);
      case DSColorStyle.light500:
        return const Color(0x33FFFFFF);
      case DSColorStyle.light400:
        return const Color(0x14FFFFFF);
      case DSColorStyle.light300:
        return const Color(0x08FFFFFF);
      case DSColorStyle.dark1000:
        return const Color(0xFF252629);
      case DSColorStyle.dark900:
        return const Color(0xFF404043);
      case DSColorStyle.dark800:
        return const Color(0xFF626265);
      case DSColorStyle.dark700:
        return const Color(0xFF858587);
      case DSColorStyle.dark600:
        return const Color(0xFFB9B9BA);
      case DSColorStyle.dark500:
        return const Color(0xFFD3D4D4);
      case DSColorStyle.dark400:
        return const Color(0xFFEEEEEE);
      case DSColorStyle.dark300:
        return const Color(0xFFF6F7F7);
    }
  }
}
