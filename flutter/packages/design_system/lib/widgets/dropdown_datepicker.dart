import 'dart:collection';

import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
final class DSDropDownDatePicker<T> extends StatefulWidget {
  final String title;
  final DateTime? initialSelectedDate;
  final Function(DateTime)? onSelected;
  TextEditingController? controller;
  final bool requestFocusOnTap;
  final TextInputType keyboardType;
  final DateFormat? dateformat;
  final bool enable;

  DSDropDownDatePicker({
    super.key,
    this.title = "",
    this.initialSelectedDate,
    this.onSelected,
    this.controller,
    this.requestFocusOnTap = false,
    this.keyboardType = TextInputType.text,
    this.dateformat,
    this.enable = true,
  }) {
    controller ??= TextEditingController();

    if (initialSelectedDate != null) {
      DateFormat dateformatter = dateformat ?? DateFormat('dd.MM.yyyy');
      controller?.text = dateformatter.format(initialSelectedDate!);
    }
  }

  @override
  State<DSDropDownDatePicker<T>> createState() =>
      _DSDropDownDatePickerState<T>();
}

class _DSDropDownDatePickerState<T> extends State<DSDropDownDatePicker<T>> {
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
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.systemError.value),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DSColorStyle.beige800.value),
      ),
    );
  }

  menuStyle() {
    return MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.green),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.0))),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        maximumSize: WidgetStatePropertyAll(Size(double.infinity, 320)),
        side: WidgetStatePropertyAll(BorderSide(color: Colors.transparent)));
  }

  @override
  Widget build(BuildContext context) {
    var menu = SizedBox(
        height: 48.0,
        child: LayoutBuilder(
            builder: (context, constraints) => DropdownMenu<CalendarLabel>(
                  enabled: widget.enable,
                  alignmentOffset: Offset(0, 4),
                  width: constraints.maxWidth,
                  enableSearch: false,
                  controller: widget.controller,
                  requestFocusOnTap: widget.requestFocusOnTap,
                  inputDecorationTheme: decoration(),
                  menuStyle: menuStyle(),
                  keyboardType: widget.keyboardType,
                  expandedInsets: EdgeInsets.all(0),
                  textStyle: DSFontStyle.bodyL.value
                      .copyWith(color: DSColorStyle.light1000.value),
                  dropdownMenuEntries: CalendarLabel.entries(
                    constraints.maxWidth,
                    widget.initialSelectedDate,
                    (args) {
                      if (args.value is DateTime) {
                        final DateTime selectedDate = args.value;

                        DateFormat dateformat =
                            widget.dateformat ?? DateFormat('dd.MM.yyyy');

                        widget.controller?.text =
                            dateformat.format(selectedDate);

                        if (widget.onSelected != null) {
                          widget.onSelected!(selectedDate);
                        }
                      }
                    },
                  ),
                  trailingIcon: SvgPicture.asset("assets/images/calendar.svg",
                      colorFilter: ColorFilter.mode(
                          DSColorStyle.light1000.value, BlendMode.srcATop)),
                  selectedTrailingIcon: SvgPicture.asset(
                      "assets/images/calendar.svg",
                      colorFilter: ColorFilter.mode(
                          DSColorStyle.beige1000.value, BlendMode.srcATop)),
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

typedef CalendarEntry = DropdownMenuEntry<CalendarLabel>;

enum CalendarLabel {
  calendar('Calendar', '1');

  const CalendarLabel(this.label, this.value);
  final String label;
  final String value;

  static List<CalendarEntry> entries(
      double maxWidth,
      DateTime? initialSelectedDate,
      Function(DateRangePickerSelectionChangedArgs) onSelectionChanged) {
    return UnmodifiableListView<CalendarEntry>(
      values.map<CalendarEntry>(
        (CalendarLabel item) => CalendarEntry(
            label: item.label,
            value: item,
            enabled: true,
            style: ButtonStyle(
              fixedSize:
                  WidgetStatePropertyAll(Size(maxWidth, maxWidth / 1.273)),
              backgroundColor:
                  WidgetStatePropertyAll(DSColorStyle.light1000.value),
              foregroundColor:
                  WidgetStatePropertyAll(DSColorStyle.light1000.value),
              overlayColor: WidgetStatePropertyAll(DSColorStyle.beige300.value),
            ),
            labelWidget: _DatePicket(
              key: GlobalKey(),
              initialSelectedDate: initialSelectedDate,
              onSelectionChanged: onSelectionChanged,
            )),
      ),
    );
  }
}

class _DatePicket extends StatefulWidget {
  final Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;
  final DateTime? initialSelectedDate;

  const _DatePicket({
    super.key,
    required this.onSelectionChanged,
    required this.initialSelectedDate,
  });

  @override
  State<_DatePicket> createState() => _DatePicketState();
}

class _DatePicketState extends State<_DatePicket>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      initialSelectedDate: widget.initialSelectedDate,
      initialDisplayDate: widget.initialSelectedDate,
      maxDate: DateTime.now(),
      backgroundColor: DSColorStyle.light1000.value,
      onSelectionChanged: widget.onSelectionChanged,
      showNavigationArrow: true,
      view: DateRangePickerView.month,
      selectionMode: DateRangePickerSelectionMode.single,
      enablePastDates: true,
      headerStyle: headerStyle(),
      monthViewSettings: monthViewSettings(),
      monthCellStyle: monthCellStyle(),
      yearCellStyle: yearCellStyle(),
      selectionTextStyle: selectionTextStyle(),
      selectionColor: DSColorStyle.beige1000.value,
    );
  }

  DateRangePickerHeaderStyle headerStyle() {
    return DateRangePickerHeaderStyle(
        backgroundColor: DSColorStyle.light1000.value,
        textAlign: TextAlign.start,
        textStyle: DSFontStyle.bodyM.value
            .copyWith(color: DSColorStyle.dark1000.value));
  }

  DateRangePickerMonthViewSettings monthViewSettings() {
    return DateRangePickerMonthViewSettings(
        firstDayOfWeek: 1,
        showTrailingAndLeadingDates: true,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: DSFontStyle.bodyXS.value
              .copyWith(color: DSColorStyle.dark1000.value),
        ));
  }

  DateRangePickerMonthCellStyle monthCellStyle() {
    return DateRangePickerMonthCellStyle(
      todayCellDecoration: const BoxDecoration(),
      textStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.dark1000.value),
      todayTextStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.beige1000.value),
      trailingDatesTextStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.dark700.value),
      leadingDatesTextStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.dark700.value),
      disabledDatesTextStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.dark500.value),
    );
  }

  TextStyle selectionTextStyle() {
    return DSFontStyle.bodyL.value
        .copyWith(color: DSColorStyle.light1000.value);
  }

  DateRangePickerYearCellStyle yearCellStyle() {
    return DateRangePickerYearCellStyle(
      todayCellDecoration: const BoxDecoration(),
      textStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.dark1000.value),
      todayTextStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.beige1000.value),
      leadingDatesTextStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.dark700.value),
      disabledDatesTextStyle:
          DSFontStyle.bodyL.value.copyWith(color: DSColorStyle.dark500.value),
    );
  }
}
