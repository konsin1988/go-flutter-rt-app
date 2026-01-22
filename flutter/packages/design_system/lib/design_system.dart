import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:flutter/material.dart';

TextStyle textStyle(DSFontStyle fontStyle, DSColorStyle color) {
  return fontStyle.value.copyWith(color: color.value);
}
