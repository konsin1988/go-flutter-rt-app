import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:rt_app/screens/widgets/title_field.dart';
import 'package:rt_app/screens/widgets/value_field.dart';

class EmailField extends StatelessWidget {
  final String field;
  final String value;

  double screenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

  const EmailField({
    super.key,
    required this.field,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        TitleField(title: 'Электронная почта'),
	      InkWell(
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
	        child: ValueField(title: value),
	      ),
    ]);
  }
}

