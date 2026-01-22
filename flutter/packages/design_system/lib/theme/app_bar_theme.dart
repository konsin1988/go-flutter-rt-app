import 'package:design_system/design_system.dart';
import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final AppBarTheme appBarDarkTheme = AppBarTheme(
    shadowColor: DSColorStyle.light300.value,
    toolbarHeight: 65.0,
    leadingWidth: 75.0,
    backgroundColor: Color(0xFF2b2c2f),
    elevation: 0.5,
    titleTextStyle: textStyle(DSFontStyle.h4, DSColorStyle.light1000),
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFF2b2c2f),
      statusBarBrightness: Brightness.dark, //iOS
      statusBarIconBrightness: Brightness.light, //Android
    ));
