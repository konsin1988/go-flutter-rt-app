import 'package:design_system/style/colors.dart';
import 'package:design_system/widgets/action_button.dart';
import 'package:flutter/material.dart';

class DSBackButton extends StatelessWidget {
  const DSBackButton({super.key, this.preAction});

  final VoidCallback? preAction;

  @override
  Widget build(BuildContext context) {
    return DSActionButton(
        onTap: () async {
          if (preAction != null) preAction!();
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.chevron_left, color: DSColorStyle.light1000.value));
  }
}
