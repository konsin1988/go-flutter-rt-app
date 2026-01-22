import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum AreaSize { large, medium, small }

extension AreaSizeExtension on AreaSize {
  EdgeInsets get padding {
    switch (this) {
      case AreaSize.large:
        return EdgeInsets.symmetric(vertical: 14, horizontal: 16);
      case AreaSize.medium:
        return EdgeInsets.symmetric(vertical: 10, horizontal: 16);
      case AreaSize.small:
        return EdgeInsets.symmetric(vertical: 6, horizontal: 12);
    }
  }
}

// ignore: must_be_immutable
class DSInputTextArea extends StatelessWidget {
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  bool enabled;
  final int maxLines;
  final AreaSize areaSize;
  final String? initialValue;
  final Function()? onTap;

  DSInputTextArea({
    super.key,
    this.textInputAction,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.areaSize = AreaSize.medium,
    this.initialValue,
    this.onTap,
  });

  InputDecoration decoration() {
    return InputDecoration(
      contentPadding: areaSize.padding,
      filled: true,
      fillColor: DSColorStyle.light300.value,
      labelStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.light1000.value),
      hintStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.light700.value),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.light500.value),
        borderRadius: BorderRadius.circular(4.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.light500.value),
        borderRadius: BorderRadius.circular(4.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.systemError.value),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.systemError.value),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.beige1000.value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      initialValue: initialValue,
      maxLines: maxLines,
      onChanged: onChanged,
      textInputAction: textInputAction,
      enabled: enabled,
      decoration: decoration(),
      cursorColor: DSColorStyle.light1000.value,
      cursorErrorColor: DSColorStyle.systemError.value,
      cursorWidth: 1.0,
      onTapOutside: (event) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          FocusManager.instance.primaryFocus?.unfocus();
        });
      },
      style:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.light1000.value),
    );
  }
}
