// ignore_for_file: no_logic_in_create_state

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:flutter/material.dart';

class DSSegmentedControlWidget extends StatefulWidget {
  final Map<String, VoidCallback> children;
  final String? initialSelectedKey;
  final double height;
  final TextStyle? customLabelStyle;

  const DSSegmentedControlWidget({
    super.key,
    required this.children,
    this.initialSelectedKey,
    this.height = 40.0,
    this.customLabelStyle,
  });

  @override
  State<DSSegmentedControlWidget> createState() => _DSSegmentedControlState(
      height: height,
      children: children,
      initialSelectedKey: initialSelectedKey ?? "",
      customLabelStyle: customLabelStyle);
}

final class _DSSegmentedControlState extends State<DSSegmentedControlWidget> {
  final Map<String, VoidCallback> children;
  String? _selectedSegment;
  final double height;
  final TextStyle? customLabelStyle;

  _DSSegmentedControlState(
      {required this.children,
      required String initialSelectedKey,
      required this.height,
      required this.customLabelStyle}) {
    if (children.containsKey(initialSelectedKey)) {
      _selectedSegment = initialSelectedKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: CustomSlidingSegmentedControl(
            height: height - 4,
            isStretch: true,
            padding: 8,
            decoration: BoxDecoration(
              color: DSColorStyle.light300.value,
              borderRadius: BorderRadius.circular(4),
            ),
            thumbDecoration: BoxDecoration(
              color: DSColorStyle.light1000.value,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                  offset: Offset(
                    0.0,
                    1.0,
                  ),
                ),
              ],
            ),
            children: {
              for (var value in children.keys)
                value: _SlideItem(
                  value: value,
                  customLabelStyle: customLabelStyle,
                  isSelected: value == _selectedSegment,
                )
            },
            onValueChanged: (value) {
              if (children.containsKey(value)) {
                children[value]!();
              }
              setState(() {
                _selectedSegment = value;
              });
            }));
  }
}

class _SlideItem extends StatelessWidget {
  const _SlideItem(
      {required this.value,
      required this.customLabelStyle,
      required this.isSelected});

  final String value;
  final TextStyle? customLabelStyle;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          softWrap: true,
          textAlign: TextAlign.center,
          maxLines: 2,
          value,
          style: (customLabelStyle ?? segmentedControlStyle).copyWith(
              color: isSelected
                  ? DSColorStyle.dark1000.value
                  : DSColorStyle.light1000.value)),
    );
  }
}
