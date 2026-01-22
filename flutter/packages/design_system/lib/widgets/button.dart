import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:flutter/material.dart';

enum ButtonSize { large, medium, small }

enum ButtonType { primary, secondary }

enum ButtonState { normal, hover, focused, disabled }

extension ButtonSizeExtension on ButtonSize {
  double get value {
    switch (this) {
      case ButtonSize.large:
        return 48.0;
      case ButtonSize.medium:
        return 40.0;
      case ButtonSize.small:
        return 32.0;
    }
  }
}

class DSButtonStyle {
  final ButtonSize btnSize;
  final ButtonType btnType;
  final ButtonState btnState;

  const DSButtonStyle({
    required this.btnSize,
    required this.btnType,
    required this.btnState,
  });
}

final class DSButton extends StatelessWidget {
  final String title;
  final DSButtonStyle style;
  final VoidCallback? onPressed;
  final Widget? icon;

  const DSButton(
      {super.key,
      this.icon,
      this.title = "",
      required this.style,
      required this.onPressed});

  Color getBackgroundColorFromStyle() {
    switch (style.btnType) {
      case ButtonType.primary:
        switch (style.btnState) {
          case ButtonState.normal:
            return DSColorStyle.light1000.value;
          case ButtonState.hover:
            return DSColorStyle.beige1000.value;
          case ButtonState.focused:
            return DSColorStyle.beige900.value;
          case ButtonState.disabled:
            return DSColorStyle.light500.value;
        }
      case ButtonType.secondary:
        switch (style.btnState) {
          case ButtonState.normal:
            return DSColorStyle.beige400.value;
          case ButtonState.hover:
            return DSColorStyle.beige500.value;
          case ButtonState.focused:
            return DSColorStyle.beige600.value;
          case ButtonState.disabled:
            return DSColorStyle.light500.value;
        }
    }
  }

  Color getFontColorFromStyle() {
    switch (style.btnType) {
      case ButtonType.primary:
        switch (style.btnState) {
          case ButtonState.normal:
          case ButtonState.hover:
          case ButtonState.focused:
            return DSColorStyle.dark1000.value;
          case ButtonState.disabled:
            return DSColorStyle.light700.value;
        }

      case ButtonType.secondary:
        switch (style.btnState) {
          case ButtonState.normal:
          case ButtonState.hover:
          case ButtonState.focused:
            return DSColorStyle.beige1000.value;
          case ButtonState.disabled:
            return DSColorStyle.light700.value;
        }
    }
  }

  double getHorizontalPadding(bool isText) {
    switch (style.btnSize) {
      case ButtonSize.large:
        return isText ? 20.0 : 14.0;
      case ButtonSize.medium:
        return isText ? 16.0 : 10.0;
      case ButtonSize.small:
        return isText ? 12.0 : 6.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      width: double.infinity,
      height: style.btnSize.value,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: getBackgroundColorFromStyle(),
        borderRadius: BorderRadius.circular(1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: style.btnState != ButtonState.disabled ? onPressed : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getHorizontalPadding(title.isNotEmpty)),
            child: () {
              if (icon != null && title.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      icon!,
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        title.toUpperCase(),
                        style: DSFontStyle.h5.value
                            .copyWith(color: getFontColorFromStyle()),
                      ),
                    ]),
                  ],
                );
              } else if (icon == null && title.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: DSFontStyle.h5.value
                              .copyWith(color: getFontColorFromStyle()),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (icon != null && title.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  getHorizontalPadding(title.isNotEmpty)),
                          child: icon!,
                        ),
                      ],
                    ),
                  ],
                );
              }
            }(),
          ),
        ),
      ),
    );
  }
}
