import 'package:flutter/material.dart';
import 'package:rt_app/style/fonts.dart';
import 'package:go_router/go_router.dart';

class ValueField extends StatelessWidget {
  final String title;
  final String? link;
  final int? id;

  const ValueField({
    required this.title,
    this.link,
    this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final textWidget = Text(
        title,
        style: RTFontStyle.ProfileValue.value.copyWith(fontSize: 15.0),
      );
	  return SizedBox(
	      width: double.infinity,
	      child: Padding(
	        padding: EdgeInsets.only(left: sw * 0.20, right: sw * 0.025),
          child: 
            link != null
            ? InkWell(
	          splashFactory: NoSplash.splashFactory, 
	          onTap: () {
	            context.push('$link/$id');
	          },
	          child: textWidget,
          )
          : textWidget,
        ),
      );
  }
}
