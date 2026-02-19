import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';

class EmailField extends StatelessWidget {
  final String field;
  final String value;

  double screenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

  const EmailField({
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
				  bottom: SW * 0.015),
	  child: InkWell(
	    onTap: () async {
  	      final Uri emailUri = Uri(
  	        scheme: 'mailto',
  	        path: value, // user email
  	      );

  	      if (await canLaunchUrl(emailUri)) {
  	        await launchUrl(emailUri);
  	      } else {
  	        debugPrint('Could not launch email app');
  	      }
  	    },
	    child: Text(
	      '$value',
	      style: RTFontStyle.ProfileValue.value.copyWith(
	        //decoration: TextDecoration.underline,
	      ),
	    ),
	  ),
	),
    ]);
  }
}

