import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';

class PhoneField extends StatelessWidget {
  final String field;
  final String value;

  double screenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

  const PhoneField({
    Key? key,
    required this.field,
    required this.value,
  }) : super(key: key);

  Future<void> _callPhoneNumber(context, String number) async {
    final sanitizedNumber = number.replaceAll(RegExp(r'[^\d+]'), '');
    final SW = screenWidth(context);
    final SH = MediaQuery.of(context).size.height;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
	backgroundColor: RTColorStyle.light700.value.withOpacity(0.99),
        title: Container(
	  width: SW * 0.9,
	  padding: EdgeInsets.symmetric(horizontal: 0.06 * SW),
	  child: Text(
	    'Начать вызов $number?',
	    style: RTFontStyle.AlertTitle.value.copyWith(fontSize: SW * 0.052),
	  ),
	),
	shape: RoundedRectangleBorder(
	  borderRadius: BorderRadius.circular(0.05 * SW),
	),
        //content: Text('Do you want to start a call to $number?'),
        actions: [
	  TextButton(
	    style: TextButton.styleFrom(
	      minimumSize: Size(0.3 * SW, 0.04 * SH),
      	      foregroundColor: RTColorStyle.dark800.value,
      	      backgroundColor: RTColorStyle.beige800.value,
      	    ),
      	    onPressed: () => Navigator.pop(context, false),
      	    child: Text(
	      'Отмена',
	      style: TextStyle(fontSize: 0.017 * SH),
	      ),
      	  ),
          TextButton(
	    style: TextButton.styleFrom(
	      minimumSize: Size(0.3 * SW, 0.04 * SH),
      	      foregroundColor: RTColorStyle.dark800.value,
      	      backgroundColor: RTColorStyle.beige800.value,
      	    ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
	      'Вызов',
	      style: TextStyle(fontSize: 0.017 * SH),
	      ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FlutterPhoneDirectCaller.callNumber(sanitizedNumber);
    }
  }

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
	  child: GestureDetector(
	    onTap: () => _callPhoneNumber(context, value),
	    child: Text(
	      '$value',
	      style: RTFontStyle.ProfileValue.value 
	    ),
	  ),
	),
    ]);
  }
}

