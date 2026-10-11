import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';

import 'package:rt_app/screens/widgets/title_field.dart';

class PhoneField extends StatelessWidget {
  final String field;
  final String value;

  double screenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

  const PhoneField({
    super.key,
    required this.field,
    required this.value,
  });


  Future<void> _callPhoneNumber(BuildContext context, String number) async {
    final sanitizedNumber = number.replaceAll(RegExp(r'[^\d+]'), '');
    final sw = screenWidth(context);
    final sh = MediaQuery.of(context).size.height;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
	backgroundColor: RTColorStyle.light700.value.withValues(alpha: 0.99),
        title: Container(
	  width: sw * 0.9,
	  padding: EdgeInsets.symmetric(horizontal: 0.06 * sw),
	  child: Text(
	    'Начать вызов $number?',
	    style: RTFontStyle.AlertTitle.value.copyWith(fontSize: sw * 0.052),
	  ),
	),
	shape: RoundedRectangleBorder(
	  borderRadius: BorderRadius.circular(0.05 * sw),
	),
        //content: Text('Do you want to start a call to $number?'),
        actions: [
	  TextButton(
	    style: TextButton.styleFrom(
	      minimumSize: Size(0.3 * sw, 0.04 * sh),
      	      foregroundColor: RTColorStyle.dark800.value,
      	      backgroundColor: RTColorStyle.beige800.value,
      	    ),
      	    onPressed: () => Navigator.pop(context, false),
      	    child: Text(
	      'Отмена',
	      style: TextStyle(fontSize: 0.017 * sh),
	      ),
      	  ),
          TextButton(
	    style: TextButton.styleFrom(
	      minimumSize: Size(0.3 * sw, 0.04 * sh),
      	      foregroundColor: RTColorStyle.dark800.value,
      	      backgroundColor: RTColorStyle.beige800.value,
      	    ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
	      'Вызов',
	      style: TextStyle(fontSize: 0.017 * sh),
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
    final sw = screenWidth(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        TitleField(title: field),
      	Padding(
	        padding: EdgeInsets.only(left: sw * 0.2, 
				  right: sw * 0.05, 
				  top: sw * 0.005, 
				  bottom: sw * 0.025),
	        child: GestureDetector(
	          onTap: () => _callPhoneNumber(context, value),
	          child: Text(
	              value,
	              style: RTFontStyle.ProfileValue.value.copyWith(fontSize: 15) 
	          ),
	        ),
	      ),
    ]);
  }
}

