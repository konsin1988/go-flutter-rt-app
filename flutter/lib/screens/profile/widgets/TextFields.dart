import 'package:flutter/material.dart';

import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';

class TextFields extends StatelessWidget {
  final String field;
  final String value;

  double screenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

  const TextFields({
    Key? key,
    required this.field,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SW = screenWidth(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
	Padding(
	  padding: EdgeInsets.only(left: SW * 0.06),
	  child: Text(
	    '$field',
	    style: RTFontStyle.ProfileField.value 
	  ),
	),
	Padding(
	  padding: EdgeInsets.only(left: SW * 0.3, 
				  right: SW * 0.05, 
				  top: SW * 0.005, 
				  bottom: SW * 0.025),
	  child: Text(
	    '$value',
	    style: RTFontStyle.ProfileValue.value 
	  ),
	),
    ]);
  }
}

