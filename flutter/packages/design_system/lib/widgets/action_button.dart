import 'package:design_system/style/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DSActionButton extends StatelessWidget {
  const DSActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final Icon icon;
  final AsyncCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 40.0,
        height: 40.0,
        child: IconButton(
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ))),
          onPressed: () => onTap.call(),
          icon: Icon(
            icon.icon,
            color: icon.color ?? DSColorStyle.beige1000.value,
            size: 22,
          ),
        ),
      ),
    );
  }
}
