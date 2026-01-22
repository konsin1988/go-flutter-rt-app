// ignore_for_file: must_be_immutable

import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:flutter/material.dart';

final class DSSearchForm extends StatelessWidget {
  final String? initialValue;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onClearPressed;
  final ValueChanged<PointerDownEvent>? onTapOutside;

  final ValueNotifier<String?> _textFromController = ValueNotifier(null);

  final String? placheholder;
  final Icon? icon;
  TextEditingController? controller;
  FocusNode? focusNode;

  DSSearchForm({
    super.key,
    this.initialValue,
    this.errorText,
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
    this.onChanged,
    this.placheholder,
    this.icon = const Icon(Icons.search),
    this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.onClearPressed,
    this.onTapOutside,
  });

  InputDecoration decoration() {
    return InputDecoration(
      contentPadding:
          EdgeInsets.only(left: 0.0, right: 2.0, top: 14.0, bottom: 14.0),
      errorText: errorText,
      errorStyle: DSFontStyle.bodyS.value
          .copyWith(color: DSColorStyle.systemError.value),
      filled: true,
      fillColor: DSColorStyle.light300.value,
      hintText: placheholder,
      prefixIcon: icon,
      prefixIconColor: DSColorStyle.light700.value,
      suffixIcon: isNotEmpty()
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: onClearPressed,
            )
          : null,
      suffixIconColor: DSColorStyle.light700.value,
      labelStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.light1000.value),
      hintStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.light700.value),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.light300.value),
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

  bool isNotEmpty() {
    if (_textFromController.value != null) return true;
    if (controller != null) {
      return controller!.text.isNotEmpty;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _textFromController,
      builder: (context, value, child) => TextFormField(
        controller: controller,
        focusNode: focusNode,
        initialValue: initialValue,
        keyboardType: keyboardType,
        onChanged: onChanged == null && controller != null
            ? ((text) => _textFromController.value = text)
            : onChanged,
        textInputAction: textInputAction,
        decoration: decoration(),
        cursorColor: DSColorStyle.light1000.value,
        cursorErrorColor: DSColorStyle.systemError.value,
        cursorWidth: 1.0,
        onEditingComplete: onEditingComplete,
        onTapOutside: onTapOutside,
      ),
    );
  }
}
