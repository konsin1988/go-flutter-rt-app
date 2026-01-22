import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final class DSDropDownMenu<T> extends StatefulWidget {
  final String title;
  final T? initialSelection;
  final ValueChanged<T?>? onSelected;
  final TextEditingController? controller;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final bool requestFocusOnTap;
  final bool enable;

  const DSDropDownMenu({
    super.key,
    this.title = "",
    this.initialSelection,
    this.onSelected,
    this.controller,
    required this.dropdownMenuEntries,
    this.requestFocusOnTap = false,
    this.enable = true,
  });

  @override
  State<DSDropDownMenu<T>> createState() => _DSDropDownMenuState<T>();
}

class _DSDropDownMenuState<T> extends State<DSDropDownMenu<T>> {
  InputDecorationTheme decoration() {
    return InputDecorationTheme(
      contentPadding:
          EdgeInsets.only(left: 16.0, right: 2.0, top: 14.0, bottom: 14.0),
      suffixIconColor: DSColorStyle.light1000.value,
      suffixIconConstraints: BoxConstraints(maxHeight: 48.0, maxWidth: 46.0),
      filled: true,
      fillColor: DSColorStyle.light300.value,
      labelStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.light1000.value),
      hintStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.light700.value),
      activeIndicatorBorder: BorderSide(color: DSColorStyle.beige800.value),
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

  menuStyle() {
    return MenuStyle(
      backgroundColor: WidgetStatePropertyAll(DSColorStyle.dark1000.value),
      shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.0))),
      padding: WidgetStatePropertyAll(EdgeInsets.zero),
      maximumSize: WidgetStatePropertyAll(Size(double.infinity, 520)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var menu = SizedBox(
        height: 48.0,
        child: LayoutBuilder(
            builder: (context, constraints) => DropdownMenu<T>(
                  enabled: widget.enable,
                  alignmentOffset: Offset(0, 4),
                  width: constraints.maxWidth,
                  enableSearch: true,
                  controller: widget.controller,
                  initialSelection: widget.initialSelection,
                  requestFocusOnTap: widget.requestFocusOnTap,
                  inputDecorationTheme: decoration(),
                  menuStyle: menuStyle(),
                  expandedInsets: EdgeInsets.all(0),
                  textStyle: DSFontStyle.bodyL.value
                      .copyWith(color: DSColorStyle.light1000.value),
                  onSelected: widget.onSelected,
                  dropdownMenuEntries: widget.dropdownMenuEntries,
                  trailingIcon: SvgPicture.asset(
                    "assets/images/drop/down.svg",
                    colorFilter: ColorFilter.mode(
                        DSColorStyle.light1000.value, BlendMode.srcIn),
                  ),
                  selectedTrailingIcon: SvgPicture.asset(
                    "assets/images/drop/up.svg",
                    colorFilter: ColorFilter.mode(
                        DSColorStyle.light1000.value, BlendMode.srcIn),
                  ),
                )));

    return widget.title.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(widget.title,
                    style: DSFontStyle.bodyL.value
                        .copyWith(color: DSColorStyle.light700.value)),
              ),
              menu,
            ],
          )
        : menu;
  }
}
