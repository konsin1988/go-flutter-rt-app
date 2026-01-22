import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
final class DSTextForm extends StatefulWidget {
  final String title;
  final String? initialValue;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  bool enabled;
  final String? placheholder;
  final Icon? icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool hardSized;
  final TextEditingController? controller;

  DSTextForm({
    super.key,
    this.title = "",
    this.initialValue,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.enabled = true,
    this.placheholder,
    this.icon,
    this.obscureText = false,
    this.validator,
    this.hardSized = true, //if TRUE - Fix const size for 20pt error message
    this.controller,
  });

  @override
  State<DSTextForm> createState() => _DSTextFormState();
}

class _DSTextFormState extends State<DSTextForm> {
  bool _isObscure = true;

  InputDecoration decoration() {
    return InputDecoration(
      contentPadding:
          EdgeInsets.only(left: 0.0, right: 0.0, top: 14.0, bottom: 14.0),
      suffixIconConstraints: widget.obscureText
          ? BoxConstraints(minHeight: 48.0, minWidth: 48)
          : BoxConstraints(),
      errorText: widget.errorText,
      prefix: SizedBox(width: 16.0),
      errorStyle: DSFontStyle.bodyS.value
          .copyWith(color: DSColorStyle.systemError.value),
      filled: true,
      fillColor: DSColorStyle.light300.value,
      hintText: widget.placheholder,
      prefixIcon: widget.icon,
      prefixIconColor: DSColorStyle.light700.value,
      suffixIcon: widget.obscureText
          ? IconButton(
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              })
          : SizedBox.shrink(),
      labelStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.light1000.value),
      hintStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.dark700.value),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.light500.value),
        borderRadius: BorderRadius.circular(1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.systemError.value),
        borderRadius: BorderRadius.circular(1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.systemError.value),
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
    var textFormField = SizedBox(
      height: widget.hardSized ? 68 : null,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        initialValue: widget.initialValue,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        textInputAction: widget.textInputAction,
        enabled: widget.enabled,
        decoration: decoration(),
        obscureText: widget.obscureText ? _isObscure : widget.obscureText,
        cursorColor: DSColorStyle.light1000.value,
        cursorErrorColor: DSColorStyle.systemError.value,
        style: DSFontStyle.bodyL.value
            .copyWith(color: DSColorStyle.light1000.value),
        cursorWidth: 1.0,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        validator: widget.validator,
      ),
    );

    return widget.title.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(widget.title,
                    style: DSFontStyle.bodyL.value
                        .copyWith(color: DSColorStyle.light800.value)),
              ),
              textFormField,
            ],
          )
        : textFormField;
  }
}
