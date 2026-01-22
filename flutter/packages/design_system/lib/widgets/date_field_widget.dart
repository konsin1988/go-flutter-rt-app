import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:flutter/material.dart';

typedef OnTapCallback = Future<void> Function();

enum DateFieldSize { large, medium, small }

extension DateFieldSizeExtension on DateFieldSize {
  EdgeInsets get padding {
    switch (this) {
      case DateFieldSize.large:
        return EdgeInsets.symmetric(vertical: 14, horizontal: 16);
      case DateFieldSize.medium:
        return EdgeInsets.symmetric(vertical: 10, horizontal: 16);
      case DateFieldSize.small:
        return EdgeInsets.symmetric(vertical: 6, horizontal: 12);
    }
  }
}

final class DSDateField extends StatelessWidget {
  final String title;
  final String? initialValue;
  final String? placheholder;
  final Icon? icon;
  final OnTapCallback? onTap;
  final TextEditingController datePickerController;
  final bool readOnly;
  final DateFieldSize areaSize;

  const DSDateField({
    super.key,
    this.title = "",
    this.initialValue,
    this.placheholder,
    this.icon = const Icon(Icons.date_range_outlined, size: 16.0),
    this.onTap,
    required this.datePickerController,
    this.readOnly = true,
    this.areaSize = DateFieldSize.medium,
  });

  InputDecoration decoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: areaSize.padding,
      hintText: placheholder,
      hintStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.light700.value),
      suffixIcon: icon,
      suffixIconConstraints: BoxConstraints(minHeight: 16, minWidth: 48.0),
      suffixIconColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.focused)
              ? DSColorStyle.beige1000.value
              : DSColorStyle.light1000.value),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.light500.value),
        borderRadius: BorderRadius.circular(1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.beige800.value),
        borderRadius: BorderRadius.circular(1.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textFormField = TextFormField(
      initialValue: initialValue,
      decoration: decoration(),
      cursorColor: Color(0xFF252629),
      cursorWidth: 1.0,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      onTap: onTap,
      controller: datePickerController,
      readOnly: readOnly,
      style:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.light1000.value),
    );

    return title.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(title,
                    style: DSFontStyle.bodyL.value
                        .copyWith(color: DSColorStyle.light800.value)),
              ),
              textFormField,
            ],
          )
        : textFormField;
  }
}
