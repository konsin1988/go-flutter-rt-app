import 'package:design_system/style/colors.dart';
import 'package:design_system/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListMenuItem extends StatelessWidget {
  const ListMenuItem({
    super.key,
    required this.title,
    required this.onPressed,
    required this.isNeedChevron,
  });

  final String title;
  final VoidCallback onPressed;
  final bool isNeedChevron;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        style: Theme.of(context).filledButtonTheme.style?.copyWith(
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0)),
              foregroundColor:
                  WidgetStateProperty.all(DSColorStyle.light1000.value),
              backgroundColor:
                  WidgetStateProperty.all(DSColorStyle.light300.value),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              )),
            ),
        onPressed: onPressed.call,
        child: Row(
          children: [
            Text(
              title,
              style: DSFontStyle.h5.value
                  .copyWith(color: DSColorStyle.light1000.value),
            ),
            const Spacer(),
            isNeedChevron
                ? SvgPicture.asset(
                    "assets/images/right.svg",
                    colorFilter: ColorFilter.mode(
                        DSColorStyle.light1000.value, BlendMode.srcIn),
                  )
                : const SizedBox.shrink()
          ],
        ));
  }
}
