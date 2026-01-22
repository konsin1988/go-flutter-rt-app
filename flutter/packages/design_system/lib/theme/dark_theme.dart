import 'package:design_system/style/colors.dart';
import 'package:design_system/theme/app_bar_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(),
  scaffoldBackgroundColor: DSColorStyle.dark1000.value,
  // primaryColor: DSColorStyle.beige1000.value,
  // primaryColorLight: DSColorStyle.text004.value,
  useMaterial3: true,
  appBarTheme: appBarDarkTheme,
  brightness: Brightness.dark,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: DSColorStyle.light1000.value,
    selectionColor: DSColorStyle.dark900.value,
    selectionHandleColor: DSColorStyle.beige900.value,
  ),
  cupertinoOverrideTheme: CupertinoThemeData(
    primaryColor: DSColorStyle
        .beige900.value, // alternative on iOS for "selectionHandleColor"
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: CupertinoPageTransitionsBuilder()
    },
  ),
  splashColor: DSColorStyle.beige500.value,
  highlightColor: DSColorStyle.beige400.value,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(3),
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      overlayColor: WidgetStateProperty.all(DSColorStyle.beige400.value),
      splashFactory: InkSplash.splashFactory,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      overlayColor: WidgetStateProperty.all(DSColorStyle.beige400.value),
      splashFactory: InkSplash.splashFactory,
    ),
  ),
  splashFactory: InkSparkle.splashFactory,
);
