import 'package:flutter/material.dart';
import 'package:rt_app/style/fonts.dart';

class TitleField extends StatelessWidget {
  final String title;

  const TitleField({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return SizedBox(
	        width: double.infinity,
	        child: Padding(
	          padding: EdgeInsets.only(left: sw * 0.04),
	          child: Text( title, style: RTFontStyle.ProfileField.value.copyWith(fontSize: 14.0),
            )
	        )
      );
  }
}
